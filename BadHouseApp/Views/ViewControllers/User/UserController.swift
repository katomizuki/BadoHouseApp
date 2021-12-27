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
    func toSettings(_ vc:UIViewController)
    func toSchedule(_ vc:UIViewController)
}
final class UserController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var groupTableView: UITableView!
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 35
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var updateUserProfileButton: UIButton! {
        didSet {
            updateUserProfileButton.layer.cornerRadius = 5
            updateUserProfileButton.layer.borderColor = UIColor.systemBlue.cgColor
            updateUserProfileButton.layer.borderWidth = 1
            updateUserProfileButton.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var myImageView: UIImageView! 
    @IBOutlet private weak var myName: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var updateProfileButton: UIButton! {
        didSet {
            updateProfileButton.addTarget(self, action: #selector(didTapUpdateProfileButton), for: .touchUpInside)
        }
    }
    private let disposeBag = DisposeBag()
    private let viewModel = UserViewModel(userAPI: UserService())
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
        viewModel.inputs.willAppear()
    }

    private func setupBinding() {
        viewModel.outputs.userName.subscribe(onNext: {[weak self] userName in
            guard let self = self else { return }
            self.myName.text = userName
        }).disposed(by: disposeBag)

        viewModel.outputs.userUrl.subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            self.myImageView.sd_setImage(with: url)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            print("エラーだよん")
        }).disposed(by: disposeBag)
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(didTapScheduleButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .done, target: self, action: #selector(didTapSettingButton))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = UIColor.white
        tabBarItem.standardAppearance = tabAppearance
      
    }
    @objc private func didTapSettingButton() {
        print(#function)
        coordinator?.toSettings(self)
        
    }
    
    @objc private func didTapScheduleButton() {
        print(#function)
        coordinator?.toSchedule(self)
    }
    
    @objc private func didTapUpdateProfileButton() {
        print(#function)
        coordinator?.toMyPage(self)
    }
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        groupTableView.register(UserProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: UserProfileHeaderView.id)
        groupTableView.showsVerticalScrollIndicator = false
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else { fatalError() }
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

extension UserController: UserProfileHeaderViewDelegate {
    func didTapSearchButton(option: UserProfileSelection) {
        switch option {
        case .circle:
            coordinator?.toSearchCircle()
        case .user:
            coordinator?.toSearchUser()
        }
    }
    
    func didTapPlusTeamButton() {
        coordinator?.toMakeCircle()
    }
}
