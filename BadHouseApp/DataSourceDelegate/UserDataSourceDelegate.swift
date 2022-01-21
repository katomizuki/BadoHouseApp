import UIKit

protocol UserDataSourceDelegateProtocol: NSObjectProtocol {
    func userDataSourceDelegate(toSearchUser user: User?)
    func userDataSourceDelegate(toSearchCircle user: User?)
    func userDataSourceDelegate(toApplyUser user: User?)
    func userDataSourceDelegate(toMakeCircle user: User?)
    func userDataSourceDelegate(toCircleDetail user: User?, circle: Circle)
    func userDataSourceDelegate(toUserDetail myData: User?, user: User)
}

final class UserDataSourceDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel: UserViewModel
    weak var delegate: UserDataSourceDelegateProtocol?
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.outputs.circleRelay.value.count
        } else {
            return viewModel.outputs.friendsRelay.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else { fatalError() }
        if indexPath.section == 1 {
            cell.configure(user: viewModel.outputs.friendsRelay.value[indexPath.row])
        } else {
            cell.configure(circle: viewModel.outputs.circleRelay.value[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.delegate?.userDataSourceDelegate(toCircleDetail: viewModel.user,
                                                  circle: viewModel.circleRelay.value[indexPath.row])
        } else if indexPath.section == 1 {
            self.delegate?.userDataSourceDelegate(toUserDetail: viewModel.user, user: viewModel.friendsRelay.value[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserProfileHeaderView.id) as? UserProfileHeaderView else { fatalError() }
        header.configure(section)
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            viewModel.inputs.withDrawCircle(viewModel.circleRelay.value[indexPath.row])
        case 1:
            viewModel.inputs.blockUser(viewModel.friendsRelay.value[indexPath.row])
        default:break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        switch indexPath.section {
        case 0:return "退会"
        case 1:return "ブロック"
        default:return ""
        }
    }
}

extension UserDataSourceDelegate: UserProfileHeaderViewDelegate {
    
    func didTapApplyButton() {
        self.delegate?.userDataSourceDelegate(toApplyUser: viewModel.user)
    }
    
    func didTapSearchButton(option: UserProfileSelection) {
        switch option {
        case .circle:
            self.delegate?.userDataSourceDelegate(toSearchCircle: viewModel.user)
        case .user:
            self.delegate?.userDataSourceDelegate(toSearchUser: viewModel.user)
        }
    }
    
    func didTapPlusTeamButton() {
        self.delegate?.userDataSourceDelegate(toMakeCircle: viewModel.user)
    }
}
