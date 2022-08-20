import UIKit
import RxSwift
import Domain

final class PreJoinedListController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: PreJoinedViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: PreJoinedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(PreJoinedCell.nib(), forCellReuseIdentifier: PreJoinedCell.id)
        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.preJoinedList.bind(to: tableView.rx.items(cellIdentifier: PreJoinedCell.id, cellType: PreJoinedCell.self)) { _, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showAlert(title: R.alertMessage.netError,
                              message: "",
                              action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            self?.showAlert(title: R.buttonTitle.join,
                              message: "",
                              action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.navigationTitle.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }
}

extension PreJoinedListController: PreJoinedCellDelegate {
    func preJoinedCell(prejoined: Domain.PreJoined) {
        viewModel.inputs.onTapPermissionButton(prejoined)
    }
}
