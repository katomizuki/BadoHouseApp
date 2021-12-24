//
//  SearchUserController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit

final class SearchUserController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView() {
        userTableView.dataSource = self
        userTableView.rowHeight = 50
        userTableView.register(SearchUserCell.nib(), forCellReuseIdentifier: SearchUserCell.id)
    }

}
extension SearchUserController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserCell.id, for: indexPath) as? SearchUserCell else { fatalError() }
        return cell
    }
}
