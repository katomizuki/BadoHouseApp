import UIKit
import RxSwift

final class TalkViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    private let viewModel: TalkViewModel
    private let coordinator: any TalkFlow
    private let disposeBag = DisposeBag()
    
    init(viewModel: TalkViewModel, coordinator: TalkFlow) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        setupTableView()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }

    private func setupTableView() {
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        tableView.refreshControl = refreshView
    }
  
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.chatRoomList.bind(to: tableView.rx.items(cellIdentifier: CustomCell.id, cellType: CustomCell.self)) { _, item, cell in
            cell.configure(chatRoom: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let uid = AuthRepositryImpl.getUid() else { return }
            self.coordinator.toChat(userId: self.viewModel.outputs.chatRoomList.value[indexPath.row].userId, myDataId: uid, chatId: self.viewModel.outputs.chatRoomList.value[indexPath.row].id)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.netError,
                            message: "",
                            action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }

    @objc private func handleRefresh() {
       
    }
}
