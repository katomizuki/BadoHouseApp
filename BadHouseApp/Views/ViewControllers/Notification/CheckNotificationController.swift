import UIKit
import RxSwift

final class CheckNotificationController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var notificationCollectionView: UICollectionView! {
        didSet { notificationCollectionView.backgroundColor = .white }
    }
    private let viewModel: NotificationViewModel
    private let disposeBag = DisposeBag()
    private let coordinator: CheckNotificationFlow
    
    init(viewModel: NotificationViewModel, coordinator: CheckNotificationFlow) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupCollectionView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupCollectionView() {
        notificationCollectionView.register(NotificationCell.nib(), forCellWithReuseIdentifier: NotificationCell.id)
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        notificationCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func setupBinding() {
        notificationCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        notificationCollectionView.rx.itemSelected.bind {[weak self] indexPath in
            self?.viewModel.inputs.didTapCell(indexPath.row)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.notificationList.bind(to: notificationCollectionView.rx.items(cellIdentifier: NotificationCell.id,
                                                cellType: NotificationCell.self)) { _, item, cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.toPrejoined.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.coordinator.toPreJoined(self.viewModel.user)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.toApplyedFriend.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.coordinator.toApplyedFriend(self.viewModel.user)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.toPracticeDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] practice in
                guard let self = self else { return }
                self.coordinator.toPracticeDetail(self.viewModel.user, practice: practice)
            }).disposed(by: disposeBag)
        
        viewModel.outputs.toUserDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.coordinator.toUserDetail(self.viewModel.user, user: user)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: R.image.shuttle.name)?.withRenderingMode(.alwaysOriginal),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRightButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: R.buttonTitle.joinWait,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapLeftButton))
    }
    
    @objc private func didTapRightButton() {
        coordinator.toPreJoined(viewModel.user)
    }
    
    @objc private func didTapLeftButton() {
        coordinator.toPreJoin(viewModel.user)
    }

}
