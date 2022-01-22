import UIKit
import RxSwift
// swiftlint:disable weak_delegate
final class BlockListController: UIViewController, UIScrollViewDelegate {
    private let disposeBag = DisposeBag()
    private let viewModel: BlockListViewModel
    private let dataSourceDelegate = BlockListDataSourceDelegate()
    @IBOutlet private weak var tableView: UITableView!
    
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
        dataSourceDelegate.initViewModel(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
    }
    
    private func setupBinding() {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok, alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
