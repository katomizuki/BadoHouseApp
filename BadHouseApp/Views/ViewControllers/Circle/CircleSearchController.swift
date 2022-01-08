import UIKit
import CDAlertView
import RxSwift

protocol CircleSearchFlow {
    func toCircleDetail(myData: User, circle: Circle?)
}
final class CircleSearchController: UIViewController {
    // MARK: - properties
    private let viewModel:SearchCircleViewModel
    private let disposeBag = DisposeBag()
    var coordinator: CircleSearchFlow?
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "場所名,サークル名等,検索"
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    init(viewModel:SearchCircleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }

    // MARK: - setupMethod
    private func setupTableView() {
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
    }
    private func setupBinding() {
        
        searchBar.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.viewModel.inputs.searchBarTextInput.onNext(text)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.circleRelay.bind(to: tableView.rx.items(cellIdentifier: CustomCell.id, cellType: CustomCell.self)) { _, item, cell in
            cell.configure(circle: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toCircleDetail(myData: self.viewModel.user,
                                             circle: self.viewModel.circleRelay.value[indexPath.row])
        }).disposed(by: disposeBag)
    }
}
