import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
protocol UserFlow:AnyObject {
    func toSearchCircle()
    func toMyPage(_ vc:UIViewController)
    func toSearchUser()
    func toDetailUser()
    func toDetailCircle()
    func toMakeCircle()
}
final class UserController: UIViewController {
    // MARK: - Properties
    private let sectionArray = ["所属チーム", "バド友"]
    var coordinator: UserFlow?
    @IBOutlet private weak var groupTableView: UITableView! {
        didSet {
            groupTableView.separatorColor = Constants.AppColor.OriginalBlue
        }
    }
    @IBOutlet weak var updateUserProfileButton: UIButton! {
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
    @IBOutlet private weak var myName: UILabel! {
        didSet {
            myName.text = Constants.appName
        }
    }
    @IBOutlet private weak var countLabel: UILabel! {
        didSet {
            countLabel.font = .boldSystemFont(ofSize: 14)
            countLabel.textColor = .systemGray
        }
    }
    private let disposeBag = DisposeBag()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - setupMethod
    private func setupData() {
       
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
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        let nib = TalkCell.nib()
        groupTableView.register(nib, forCellReuseIdentifier:TalkCell.id)
    }
}
// MARK: - UItableViewDataSource
extension UserController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
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
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemGray6
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
}

// MARK: - UserDismissDelegate
extension UserController: UserDismissDelegate {
    func userVCdismiss(vc: UserPageController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

