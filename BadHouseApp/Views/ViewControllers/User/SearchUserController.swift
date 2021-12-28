//
//  SearchUserController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
import RxSwift
import SDWebImage
final class SearchUserController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    private let viewModel = SearchUserViewModel(userAPI: UserService())
    private let disposeBag = DisposeBag()
    private var user: User
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    init(user:User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupTableView() {
        userTableView.rowHeight = 50
        userTableView.register(SearchUserCell.nib(), forCellReuseIdentifier: SearchUserCell.id)
    }
    private func setupBinding() {
        userTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().subscribe(onNext: { [weak self] text in
                self?.viewModel.inputs.searchTextInput.onNext(text)
            }).disposed(by: disposeBag)
        
        viewModel.outputs.usersSubject.bind(to: userTableView.rx.items(cellIdentifier: SearchUserCell.id, cellType: SearchUserCell.self)) {
            _, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        userTableView.rx.itemSelected.asDriver().drive { [weak self] _ in
            let controller = MainUserDetailController.init(nibName: "MainUserDetailController", bundle: nil)
            self?.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)

    }

}
extension SearchUserController: SearchUserCellDelegate {
    func searchUserCell(_ user: User, cell: SearchUserCell) {
        viewModel.applyFriend(user,myData: self.user)
    }
}
