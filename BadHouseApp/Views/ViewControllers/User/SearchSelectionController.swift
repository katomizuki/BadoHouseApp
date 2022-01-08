//
//  SearchSelectionController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/02.
//

import UIKit
protocol SearchSelectionControllerDelegate:AnyObject {
    func searchSelectionControllerDismiss(vc: SearchSelectionController,
                        selection: SearchSelection,
                        text: String)
}
class SearchSelectionController: UIViewController {
    private let cellId = "popCellId"
    private var cellArray = [String]()
    var keyWord: SearchSelection = .level
    weak var delegate:SearchSelectionControllerDelegate?
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tb
    }()
    var (age,
         place,
         badmintonTime,
         gender) = (String(), String(), String(), String())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        switch keyWord {
        case .place:
            cellArray = Place.placeArray
        case .level:
            cellArray = BadmintonLevel.level
            }
        tableView.reloadData()
    }

}
extension SearchSelectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedString = cellArray[indexPath.row]
        self.delegate?.searchSelectionControllerDismiss(vc: self, selection: keyWord, text: selectedString)
    }
}
extension SearchSelectionController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = cellArray[indexPath.row]
        cell.contentConfiguration = configuration
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
}
