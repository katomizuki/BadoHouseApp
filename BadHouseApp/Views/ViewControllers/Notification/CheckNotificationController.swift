import UIKit
import RxSwift

protocol CheckNotificationFlow: AnyObject {
    func toUserDetail(_ myData: User, user: User)
    func toPracticeDetail(_ myData: User, practice: Practice)
    func toPreJoin(_ user: User)
    func toPreJoined(_ user: User)
    func toApplyedFriend(_ user: User)
}

final class CheckNotificationController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var notificationCollectionView: UICollectionView! {
        didSet { notificationCollectionView.backgroundColor = .white }
    }
    var coordinator: CheckNotificationFlow?
    private let viewModel: NotificationViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupBinding()
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
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
                self.coordinator?.toPreJoined(self.viewModel.user)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.toApplyedFriend.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.toApplyedFriend(self.viewModel.user)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.toPracticeDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] practice in
                guard let self = self else { return }
                self.coordinator?.toPracticeDetail(self.viewModel.user, practice: practice)
            }).disposed(by: disposeBag)
        
        viewModel.outputs.toUserDetail.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.coordinator?.toUserDetail(self.viewModel.user, user: user)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: R.image.shuttle.name)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(didTapRightButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: R.buttonTitle.joinWait, style: .done, target: self, action: #selector(didTapLeftButton))
    }
    
    @objc private func didTapRightButton() {
        coordinator?.toPreJoined(viewModel.user)
    }
    
    @objc private func didTapLeftButton() {
        coordinator?.toPreJoin(viewModel.user)
    }

}
