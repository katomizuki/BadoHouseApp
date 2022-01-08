import UIKit
import CDAlertView
import RxSwift
protocol TalkFlow: AnyObject {
    func toChat(userId: String, myDataId:String, chatId: String)
}
final class TalkViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    private let viewModel = TalkViewModel(userAPI: UserService(), chatAPI: ChatService())
    var coordinator: TalkFlow?
    private let disposeBag = DisposeBag()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.backButtonDisplayMode = .minimal
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
    }

    private func setupTableView() {
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        tableView.addSubview(refreshView)
    }
  
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.chatRoomList.bind(to: tableView.rx.items(cellIdentifier: CustomCell.id, cellType: CustomCell.self)) { _,item,cell in
            cell.configure(chatRoom: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let uid = AuthService.getUid() else { return }
            self.coordinator?.toChat(userId: self.viewModel.outputs.chatRoomList.value[indexPath.row].userId, myDataId: uid, chatId: self.viewModel.outputs.chatRoomList.value[indexPath.row].id)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラー", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)

    }

    @objc private func handleRefresh() {
       
    }
}
