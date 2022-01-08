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
    private let viewModel: ApplyFriendsViewModel
    init(viewModel: ApplyFriendsViewModel) {
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
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラー", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.applyRelay.bind(to: tableView.rx.items(cellIdentifier:ApplyUserListCell.id, cellType: ApplyUserListCell.self)) { _, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)

    }
}

extension ApplyFriendController: ApplyUserListCellDelegate {
    func onTapTrashButton(_ apply: Apply, cell: ApplyUserListCell) {
        viewModel.inputs.onTrashButton(apply: apply)
    }
}
