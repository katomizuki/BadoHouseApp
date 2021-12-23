//
//  FriendsListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/23.
//

import UIKit

final class FriendsListController: UIViewController {

    @IBOutlet private weak var friendListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.backButtonDisplayMode = .minimal
    }
    private func setupTableView() {
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        friendListTableView.register(MemberCell.nib(), forCellReuseIdentifier: MemberCell.id)
    }
}
extension FriendsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let controller = MainUserDetailController.init(nibName: "MainUserDetailController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension FriendsListController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberCell.id, for: indexPath) as? MemberCell else { fatalError() }
        return cell
    }
}
