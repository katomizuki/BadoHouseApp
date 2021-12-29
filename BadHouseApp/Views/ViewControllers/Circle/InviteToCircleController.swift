import UIKit
import RxSwift
import PKHUD
final class InviteToCircleController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties
    @IBOutlet private weak var friendTableView: UITableView!
    var viewModel: InviteViewModel!
    private let disposeBag = DisposeBag()
    private var selectedCell: [String:Bool] = [String:Bool]()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
    }
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "サークルへ招待",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapRightButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    private func setupBinding() {
        friendTableView.register(InviteCell.nib(), forCellReuseIdentifier: InviteCell.id)
        friendTableView.rowHeight = 50
        friendTableView.rx.setDelegate(self).disposed(by: disposeBag)
        friendTableView.allowsMultipleSelection = true
        
        viewModel.outputs.friendsList
            .bind(to: friendTableView.rx.items(cellIdentifier: InviteCell.id, cellType: InviteCell.self)) {[weak self] row, item, cell in
            cell.configure(item)
                cell.accessoryType = self?.selectedCell["\(row)"] != nil ? .checkmark : .none
        }.disposed(by: disposeBag)
        
        friendTableView.rx.itemSelected.asDriver().drive(onNext: { [weak self] indexPath in
            guard let cell = self?.friendTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .checkmark
            self?.selectedCell["\(indexPath.row)"] = true
            self?.viewModel.inviteAction(user: self?.viewModel.friendsList.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        friendTableView.rx.itemDeselected.asDriver().drive(onNext: {[weak self] indexPath in
            guard let cell = self?.friendTableView.cellForRow(at: indexPath) else { return }
            cell.accessoryType = .none
            self?.selectedCell["\(indexPath.row)"] = nil
            self?.viewModel.inviteAction(user: self?.viewModel.friendsList.value[indexPath.row])
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isCompleted
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)

    }
    @objc private func didTapRightButton() {
        viewModel.makeCircle()
        HUD.show(.success, onView: view)
    }
}
