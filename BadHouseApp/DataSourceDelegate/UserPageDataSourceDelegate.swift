import UIKit

protocol UserPageDataSourceDelegateProtocol: NSObjectProtocol {
    func pop()
    func push(_ vc: UserLevelController)
    func present(_ vc: MyPageInfoPopoverController)
}

final class UserPageDataSourceDelegate: NSObject, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, PopDismissDelegate, UserLevelDelegate {
    
    let viewModel: UpdateUserInfoViewModel
    private let cellId = "cellId"
    weak var delegate: UserPageDataSourceDelegateProtocol?
    
    init(viewModel: UpdateUserInfoViewModel) {
        self.viewModel = viewModel
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfoSelection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellId)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = UserInfoSelection(rawValue: indexPath.row)?.description
        configuration.secondaryText = viewModel.getUserData(UserInfoSelection(rawValue: indexPath.row)!)
        cell.contentConfiguration = configuration
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserInfoSelection(rawValue: indexPath.row) == .level {
            let controller = BadHouseApp.UserLevelController.init(user: viewModel.user!)
            controller.delegate = self
            self.delegate?.push(controller)
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return }
                let viewController = MyPageInfoPopoverController()
                viewController.modalPresentationStyle = .popover
                viewController.preferredContentSize = CGSize(width: 200, height: 150)
                viewController.delegate = self
                let presentationController = viewController.popoverPresentationController
                presentationController?.delegate = self
                presentationController?.permittedArrowDirections = .up
                presentationController?.sourceView = cell
                presentationController?.sourceRect = cell.bounds
                viewController.keyword = UserInfoSelection(rawValue: indexPath.row) ?? .level
                viewController.presentationController?.delegate = self
            self.delegate?.present(viewController)
            }
        }
    
    func popDismiss(vc: MyPageInfoPopoverController, userInfoSelection: UserInfoSelection, text: String) {
        viewModel.changeUser(userInfoSelection, text: text)
        vc.dismiss(animated: true)
    }
    
    func UserLevelController(vc: UserLevelController, text: String) {
        viewModel.changeUser(.level, text: text)
        self.delegate?.pop()
    }
}
