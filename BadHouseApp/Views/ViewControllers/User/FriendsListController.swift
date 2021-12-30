//
//  FriendsListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/23.
//

import UIKit
import RxSwift

protocol FriendListFlow:AnyObject {
    func toUserDetail(myData:User,user:User)
}
final class FriendsListController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var friendListTableView: UITableView!
    var coordinator: FriendListFlow?
    var viewModel: FriendsListViewModel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        navigationItem.backButtonDisplayMode = .minimal
    }
    private func setupBinding() {
        friendListTableView.register(MemberCell.nib(), forCellReuseIdentifier: MemberCell.id)
        friendListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.usersRelay.bind(to: friendListTableView.rx.items(cellIdentifier: MemberCell.id, cellType: MemberCell.self)) {_, item, cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        friendListTableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toUserDetail(myData:self.viewModel.myData,
                                           user: self.viewModel.usersRelay.value[indexPath.row])
        }).disposed(by: disposeBag)
    }
}
