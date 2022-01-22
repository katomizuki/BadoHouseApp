import UIKit
import RxSwift
import PKHUD

final class AddtionalMemberController: UIViewController, UIScrollViewDelegate {
    
    private let viewModel: AdditionalMemberViewModel
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var selectedCell: [String: Bool] = [String: Bool]()
    
    init(viewModel: AdditionalMemberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupBinding()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.buttonTitle.invite, style: .done, target: self, action: #selector(didTapRightButton))
    }
    
    private func setupTableView() {
        tableView.register(InviteCell.nib(), forCellReuseIdentifier: InviteCell.id)
    }
    
    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.outputs.friendsSubject.bind(to: tableView.rx.items(cellIdentifier: InviteCell.id, cellType: InviteCell.self)) {[weak self] row, item, cell in
            cell.configure(item)
            cell.accessoryType = self?.selectedCell["\(row)"] != nil ? .checkmark : .none
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let cell = self?.tableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .checkmark
            self?.selectedCell["\(indexPath.row)"] = true
            self?.viewModel.inviteAction(user: self?.viewModel.outputs.friendsSubject.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected.asDriver().drive(onNext: {[weak self] indexPath in
            guard let cell = self?.tableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .none
            self?.selectedCell["\(indexPath.row)"] = nil
            self?.viewModel.inviteAction(user: self?.viewModel.outputs.friendsSubject.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: R.alertMessage.netError,
                              message: "",
                              action: R.alertMessage.ok,
                              alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            self?.popAnimation()
        }.disposed(by: disposeBag)

    }
    
    @objc private func didTapRightButton() {
        viewModel.inputs.invite()
    }
    
    private func popAnimation() {
        HUD.show(.success, onView: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
