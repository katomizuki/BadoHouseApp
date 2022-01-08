import UIKit
import RxSwift

final class ApplyedUserListController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: ApplyedUserListViewModel
    init(viewModel: ApplyedUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
        navigationItem.backButtonDisplayMode = .minimal
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
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completedFriend.subscribe(onNext: { [weak self] text in
            self?.showCDAlert(title: "\(text)さんとバド友になりました", message: "", action: "OK", alertType: .success)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.applyedRelay.bind(to: tableView.rx.items(cellIdentifier: ApplyedUserListCell.id, cellType: ApplyedUserListCell.self)) {
            _, item, cell in
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
