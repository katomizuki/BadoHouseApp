import UIKit
import RxSwift
import SDWebImage

final class ApplyFriendController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel: ApplyFriendsViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ApplyFriendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = R.navTitle.friends
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupBinding() {
        tableView.register(ApplyUserListCell.nib(), forCellReuseIdentifier: ApplyUserListCell.id)
        tableView.rowHeight = 60
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.isError.subscribe { [weak self] _ in
            self?.showAlert(title: R.alertMessage.netError,
                              message: "",
                              action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.applyRelay.bind(to: tableView.rx.items(cellIdentifier: ApplyUserListCell.id, cellType: ApplyUserListCell.self)) { _, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
    }
}

extension ApplyFriendController: ApplyUserListCellDelegate {
    func onTapTrashButton(_ apply: Apply, cell: ApplyUserListCell) {
        viewModel.inputs.onTrashButton(apply: apply)
    }
}
