import UIKit
import RxSwift

protocol PracticeSearchControllerDelegate: AnyObject {
    func eventSearchControllerDismiss(practices:[Practice], vc: PracticeSearchController)
}
final class PracticeSearchController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PracticeSearchViewModel
    private let dataSourceDelegate = PracticeDataSourceDelegate()
    weak var delegate: PracticeSearchControllerDelegate?
    @IBOutlet private weak var searchSelectionTableView: UITableView! {
        didSet { searchSelectionTableView.changeCorner(num: 8) }
    }
    @IBOutlet private weak var startPicker: UIDatePicker! {
        didSet {
            startPicker.addTarget(self, action: #selector(changeStartPicker), for: .valueChanged)
        }
    }
    @IBOutlet private weak var finishPicker: UIDatePicker! {
        didSet {
            finishPicker.addTarget(self, action: #selector(changeFinishPicker), for: .valueChanged)
        }
    }
    init(viewModel: PracticeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceDelegate.initViewModel(viewModel: viewModel)
        setupTableView()
        setupNavigationBar()
        setupBinding()
        navigationItem.title = "\(viewModel.fullPractices.count)件のヒット"
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearchButton)), UIBarButtonItem(barButtonSystemItem: .refresh,
                            target: self,
                            action: #selector(didTapReloadButton))]
    }
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    @objc private func didTapSearchButton() {
        self.delegate?.eventSearchControllerDismiss(practices: viewModel.practices, vc: self)
    }
    @objc private func changeFinishPicker(sender: UIDatePicker) {
        let date = sender.date
        viewModel.inputs.changeFinishPicker(date)
    }
    @objc private func changeStartPicker(sender: UIDatePicker) {
        let date = sender.date
        viewModel.inputs.changeStartPicker(date)
    }
    @objc private func didTapReloadButton() {
        self.showCDAlert(title: "検索条件をクリアしました!", message: "", action: "OK", alertType: .success)
        viewModel.inputs.refresh()
    }
    private func setupBinding() {
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.searchSelectionTableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.navigationStriing.subscribe(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }
    private func setupTableView() {
        searchSelectionTableView.delegate = dataSourceDelegate
        searchSelectionTableView.dataSource = dataSourceDelegate
        dataSourceDelegate.delegate = self
        searchSelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
}
extension PracticeSearchController: PracticeDataSourceDelegateProtocol {
    func presentVC(_ vc: SearchSelectionController) {
        present(vc, animated: true)
    }
}
