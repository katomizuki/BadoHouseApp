import UIKit
import RxSwift

final class ApplyedUserListController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel: ApplyedUserListViewModel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.register(ApplyedUserListCell.nib(), forCellReuseIdentifier: ApplyedUserListCell.id)
    }
    private func setupBinding() {
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
    }
}
extension ApplyedUserListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyedUserListCell.id, for: indexPath) as? ApplyedUserListCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configure(applyed: viewModel.outputs.applyedSubject.value[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.applyedSubject.value.count
    }
}
extension ApplyedUserListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
extension ApplyedUserListController: ApplyedUserListCellDelegate {
    func onTapPermissionButton(_ applyed:Applyed) {
        viewModel.inputs.makeFriends(applyed)
    }
}
