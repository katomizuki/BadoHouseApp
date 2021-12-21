import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

protocol UserFlow: AnyObject {
    func toSearchCircle()
    func toMyPage(_ vc: UIViewController)
    func toSearchUser()
    func toDetailUser()
    func toDetailCircle()
    func toMakeCircle()
}
final class UserController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var groupTableView: UITableView!
    @IBOutlet private weak var updateUserProfileButton: UIButton! {
        didSet {
            updateUserProfileButton.layer.cornerRadius = 5
            updateUserProfileButton.layer.borderColor = UIColor.systemBlue.cgColor
            updateUserProfileButton.layer.borderWidth = 1
            updateUserProfileButton.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var myImageView: UIImageView! {
        didSet {
            myImageView.toCorner(num: 35)
        }
    }
    @IBOutlet private weak var myName: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var updateProfileButton: UIButton! {
        didSet {
            updateProfileButton.addTarget(self, action: #selector(didTapUpdateProfileButton), for: .touchUpInside)
        }
    }
    private let disposeBag = DisposeBag()
    var coordinator: UserFlow?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func setupBinding() {
        
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(didTapScheduleButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .done, target: self, action: #selector(didTapSettingButton))
    }
    @objc private func didTapSettingButton() {
        print(#function)
        
    }
    
    @objc private func didTapScheduleButton() {
        print(#function)
    }
    
    @objc private func didTapUpdateProfileButton() {
        print(#function)
        coordinator?.toMyPage(self)
    }
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.register(TalkCell.nib(), forCellReuseIdentifier: TalkCell.id)
        let nib = UserProfileHeaderView.self
        groupTableView.register(nib, forHeaderFooterViewReuseIdentifier: UserProfileHeaderView.id)
    }
}
// MARK: - UItableViewDataSource
extension UserController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TalkCell.id, for: indexPath) as? TalkCell else { fatalError() }
        if indexPath.section == 0 {
       
        } else if indexPath.section == 1 {
           
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension UserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            coordinator?.toDetailCircle()
        } else if indexPath.section == 1 {
            coordinator?.toDetailUser()
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
    
}

// MARK: - UserDismissDelegate
extension UserController: UserDismissDelegate {
    func userVCdismiss(vc: UserPageController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
extension UserController:UserProfileHeaderViewDelegate {
    func userProfileHeaderView(_ view: UserProfileHeaderView, section: Int, option: UserProfileSelection) {
        
    }
}
