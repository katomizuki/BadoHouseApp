import UIKit
import RxSwift

final class AddtionalMemberController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var selectedCell: [String: Bool] = [String: Bool]()
    private let viewModel: AdditionalMemberViewModel
    
    init(viewModel: AdditionalMemberViewModel) {
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
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.buttonTitle.invite, style: .done, target: self, action: #selector(didTapRightButton))
    }
    
    private func setupTableView() {
        tableView.register(InviteCell.nib(), forCellReuseIdentifier: InviteCell.id)
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.outputs.friendsSubject.bind(to: tableView.rx.items(cellIdentifier: InviteCell.id, cellType: InviteCell.self)) { [weak self] row, item, cell in
            guard let self = self else { return }
            cell.configure(item)
            cell.accessoryType = self.selectedCell["\(row)"] != nil ? .checkmark : .none
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .checkmark
            self.selectedCell["\(indexPath.row)"] = true
            self.viewModel.inviteAction(user: self.viewModel.outputs.friendsSubject.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected.asDriver().drive(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .none
            self.selectedCell["\(indexPath.row)"] = nil
            self.viewModel.inviteAction(user: self.viewModel.outputs.friendsSubject.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.netError,
                              message: "",
                              action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.popAnimation()
        }.disposed(by: disposeBag)

    }
    
    @objc private func didTapRightButton() {
        viewModel.inputs.invite()
    }
    
    private func popAnimation() {
        // TODO: - 何かしらのFBが欲しい
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
