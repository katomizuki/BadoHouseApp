import UIKit
import RxSwift

final class ApplyedUserListController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var tableView: UITableView!

    private let viewModel: ApplyedUserListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ApplyedUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    
    private func setupNavigationItem() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
        setupNavigationItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.register(ApplyedUserListCell.nib(), forCellReuseIdentifier: ApplyedUserListCell.id)
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completedFriend.subscribe(onNext: { [weak self] text in
            self?.showAlert(title: "\(text)さんとバド友になりました",
                              message: "",
                              action: R.alertMessage.ok)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.applyedRelay.bind(to: tableView.rx.items(cellIdentifier: ApplyedUserListCell.id, cellType: ApplyedUserListCell.self)) {_, item, cell in
            cell.delegate = self
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.bind { indexPath in
            self.viewModel.inputs.deleteFriends(self.viewModel.applyedRelay.value[indexPath.row])
        }.disposed(by: disposeBag)
        
        viewModel.outputs.navigationTitle.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
        
        viewModel.outputs.navigationTitle.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }
}

extension ApplyedUserListController: ApplyedUserListCellDelegate {
    func onTapPermissionButton(_ applyed: Applyed) {
        viewModel.inputs.makeFriends(applyed)
    }
}
