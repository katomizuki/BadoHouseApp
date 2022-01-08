//
//  ApplyFriendController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import UIKit
import RxSwift
import SDWebImage

final class ApplyFriendController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel:ApplyFriendsViewModel
    init(viewModel:ApplyFriendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        navigationItem.title = "バド友申請一覧"
    }
    private func setupBinding() {
        tableView.register(ApplyUserListCell.nib(), forCellReuseIdentifier: ApplyUserListCell.id)
        tableView.rowHeight = 60
        tableView.dataSource = self
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラー", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)

    }
}
extension ApplyFriendController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyUserListCell.id, for: indexPath) as? ApplyUserListCell else { return UITableViewCell() }
        cell.configure(viewModel.outputs.applySubject.value[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.applySubject.value.count
    }
}

extension ApplyFriendController: ApplyUserListCellDelegate {
    func onTapTrashButton(_ apply: Apply, cell: ApplyUserListCell) {
        viewModel.inputs.onTrashButton(apply: apply)
    }
}
