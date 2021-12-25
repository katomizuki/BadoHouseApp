//
//  EventSearchController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
protocol EventSearchFlow:AnyObject {
    
}
final class EventSearchController: UIViewController {
    @IBOutlet private weak var searchSelectionTableView: UITableView! {
        didSet { searchSelectionTableView.changeCorner(num: 8) }
    }
    var coordinator:EventSearchFlow?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView() {
        searchSelectionTableView.delegate = self
        searchSelectionTableView.dataSource = self
        searchSelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }


}
extension EventSearchController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension EventSearchController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchSelection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = SearchSelection(rawValue: indexPath.row)?.description
        cell.contentConfiguration = configuration
        return cell
    }
    
}

