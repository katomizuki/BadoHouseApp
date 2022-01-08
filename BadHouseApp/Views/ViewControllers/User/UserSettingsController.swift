//
//  UserSettingsController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/22.
//

import UIKit
import FirebaseAuth
final class UserSettingsController: UIViewController {
    var user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    @IBOutlet private weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.changeCorner(num: 8)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        settingsTableView.showsVerticalScrollIndicator = true
    }
    private func setupNavigationBar() {
        navigationItem.title = "設定画面"
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト",style: .done, target: self, action: #selector(didTapLogoutButton))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapLogoutButton() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
}
extension UserSettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BlockListController.init(nibName: "BlockListController", bundle: nil), animated: true)
        case 1:
            navigationController?.pushViewController(MyPracticeController.init(viewModel: MyPracticeViewModel(user: user, userAPI: UserService())), animated: true)
        case 2:
            let viewController = AppExplainController()
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 200, height: 300)
            let presentationController = viewController.popoverPresentationController
            presentationController?.delegate = self
            presentationController?.permittedArrowDirections = .up
            presentationController?.sourceView = cell
            presentationController?.sourceRect = cell.bounds
            viewController.presentationController?.delegate = self
            present(viewController, animated: true, completion: nil)
        case 3:
            navigationController?.pushViewController(RuleController(), animated: true)
        case 4:
            navigationController?.pushViewController(ProblemInformationController.init(nibName: "ProblemInformationController", bundle: nil), animated: true)
        default:break
        }
        
    }
}
extension UserSettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = SettingsSelection(rawValue: indexPath.row)?.description
        cell.contentConfiguration = configuration
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsSelection.allCases.count
    }
    
}
extension UserSettingsController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
