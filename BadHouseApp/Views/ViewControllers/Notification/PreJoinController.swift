import UIKit
import RxSwift
import RxCocoa

final class PreJoinController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private let viewModel: PreJoinViewModel
    
    init(viewModel: PreJoinViewModel) {
        self.viewModel = viewModel
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
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(PreJoinCell.nib(), forCellReuseIdentifier: PreJoinCell.id)
        tableView.rowHeight = 60
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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.preJoinList.bind(to: tableView.rx.items(cellIdentifier: PreJoinCell.id, cellType: PreJoinCell.self)) {_, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
    }
}

extension PreJoinController: PreJoinCellDelegate {
    func preJoinCell(_ cell: PreJoinCell, preJoin: PreJoin) {
        viewModel.inputs.delete(preJoin)
    }
}
