import UIKit
import Firebase

final class PlusTeamPlayerController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var inviteButton: UIButton! {
        didSet {
            inviteButton.layer.cornerRadius = 15
            inviteButton.layer.masksToBounds = true
            inviteButton.setTitleColor(.systemGray6, for: .normal)
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    var friends = [User]()
    var inviter = [User]()
    var team: TeamModel?
    private var cellId = Constants.CellId.inviteCellId
    // Mark CustomDelegate
    func someMethodWantToCall(cell: UITableViewCell) {
        print(#function)
        let indexPathTapped = tableView.indexPath(for: cell)
        guard let index = indexPathTapped?[1] else { return }
        let friend = friends[index]
        if judgeInvite(userId: friend.uid) != nil {
            guard let  index = judgeInvite(userId: friend.uid) else { return }
            inviter.remove(at: index)
        } else {
            inviter.append(friend)
        }
    }
    // MARK: - HelperMethod
    func judgeInvite(userId: String) -> Int? {
        if inviter.isEmpty { return nil }
        for i in 0..<inviter.count {
            let friendId = inviter[i].uid
            if friendId == userId { return i }
        }
        return nil
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.AppColor.OriginalBlue]
    }
    // MARK: - SetupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlusTeamPlayersCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    // MARK: - IBAction
    @IBAction func invite(_ sender: Any) {
        print(#function)
        guard let team = self.team else {
            return }
        TeamService.sendInviteToTeamData(team: team, inviter: self.inviter)
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - TableViewDataSource
extension PlusTeamPlayerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlusTeamPlayersCell
        cell.linkInvite = self
        cell.nameLabel.text = friends[indexPath.row].name
        cell.tintColor = Constants.AppColor.OriginalBlue
        let urlString = friends[indexPath.row].profileImageUrl
        let url = URL(string: urlString)
        if urlString == "" {
            cell.iv.image = UIImage(named: Constants.ImageName.logoImage)
        } else {
            cell.iv.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
}
// MARK: - TableViewDelegate
extension PlusTeamPlayerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
