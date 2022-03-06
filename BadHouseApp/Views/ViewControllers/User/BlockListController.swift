import UIKit
import RxSwift
// swiftlint:disable weak_delegate
final class BlockListController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel: BlockListViewModel
    private let dataSourceDelegate = BlockListDataSourceDelegate()
    
    init(viewModel: BlockListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupViewModel()
    }
    
    private func setupViewModel() {
        dataSourceDelegate.initViewModel(viewModel: viewModel)
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
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)

        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
