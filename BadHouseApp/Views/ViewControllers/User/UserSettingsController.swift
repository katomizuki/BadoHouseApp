//
//  UserSettingsController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/22.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

final class UserSettingsController: UIViewController {

    
    @IBOutlet private weak var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "settingsId")
    }


}
extension UserSettingsController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
extension UserSettingsController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsId",for: indexPath)
        cell.textLabel?.text = "パスワード変更"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
