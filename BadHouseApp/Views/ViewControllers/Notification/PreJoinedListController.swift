import UIKit
import RxSwift

final class PreJoinedListController: UIViewController, UIScrollViewDelegate {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: PreJoinedViewModel
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
        tableView.register(PreJoinedCell.nib(), forCellReuseIdentifier: PreJoinedCell.id)
        tableView.rowHeight = 60
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
    }
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.preJoinedList.bind(to: tableView.rx.items(cellIdentifier: PreJoinedCell.id, cellType: PreJoinedCell.self)) { _, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            self?.showCDAlert(title: "承認しました", message: "", action: "OK", alertType: .success)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.navigationTitle.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }
}
extension PreJoinedListController: PreJoinedCellDelegate {
    func preJoinedCell(prejoined: PreJoined) {
        viewModel.inputs.permission(prejoined)
    }
}
