import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

protocol UserFlow: AnyObject {
    func toSearchCircle(user: User?)
    func toMyPage(_ vc: UIViewController)
    func toSearchUser(user: User?)
    func toDetailUser(myData: User?, user: User?)
    func toDetailCircle(myData: User?, circle: Circle?)
    func toMakeCircle(user: User?)
    func toSettings(_ vc: UIViewController, user: User?)
    func toSchedule(_ vc: UIViewController, user: User?)
    func toApplyUser(user: User?)
    func toApplyedUser(user: User?)

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
    @IBOutlet private weak var applyView: UIView!
    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var myName: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var updateProfileButton: UIButton! {
        didSet {
            updateProfileButton.addTarget(self, action: #selector(didTapUpdateProfileButton), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var friendCountLabel: UILabel!
    private let disposeBag = DisposeBag()
    private let viewModel = UserViewModel(userAPI: UserService(), applyAPI: ApplyService())
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
            self?.myName.text = userName
        }).disposed(by: disposeBag)

        viewModel.outputs.userUrl.subscribe(onNext: { [weak self] url in
            self?.myImageView.sd_setImage(with: url)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.userCircleCountText.subscribe(onNext: { [weak self] text in
            self?.countLabel.text = text
        }).disposed(by: disposeBag)
        
        viewModel.outputs.userFriendsCountText.subscribe(onNext: { [weak self] text in
            self?.friendCountLabel.text = text
        }).disposed(by: disposeBag)

        viewModel.outputs.isError.subscribe(onNext: { [weak self] _ in
            self?.showCDAlert(title: "通信エラーになりました", message: "", action: "OK", alertType: .warning)
        }).disposed(by: disposeBag)
        
        applyView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                self?.coordinator?.toApplyedUser(user: self?.viewModel.user)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.isApplyViewHidden
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isHidden in
                self?.applyView.isHidden = isHidden
            }).disposed(by: disposeBag)
        
        viewModel.outputs.reload
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.groupTableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.outputs.notAuth.subscribe(on: MainScheduler.instance)
            .subscribe {[weak self] _  in
                guard let self = self else { return }
                let vc = self.tabBarController?.viewControllers?[0]
                self.tabBarController?.selectedViewController = vc
            }.disposed(by: disposeBag)
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
    }
    @objc private func didTapSettingButton() {
        coordinator?.toSettings(self, user: viewModel.user)
    }
    
    @objc private func didTapScheduleButton() {
        coordinator?.toSchedule(self, user: viewModel.user)
    }
    
    @objc private func didTapUpdateProfileButton() {
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
}
// MARK: - UITableViewDelegate
extension UserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            coordinator?.toDetailCircle(myData: viewModel.user,
                                        circle: viewModel.circleRelay.value[indexPath.row])
        } else if indexPath.section == 1 {
            coordinator?.toDetailUser(myData: viewModel.user,
                                      user: viewModel.friendsRelay.value[indexPath.row])
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

extension UserController: UserProfileHeaderViewDelegate {
    func didTapApplyButton() {
        coordinator?.toApplyUser(user: viewModel.user)
    }
    
    func didTapSearchButton(option: UserProfileSelection) {
        switch option {
        case .circle:
            coordinator?.toSearchCircle(user: viewModel.user)
        case .user:
            coordinator?.toSearchUser(user: viewModel.user)
        }
    }
    
    func didTapPlusTeamButton() {
        coordinator?.toMakeCircle(user: viewModel.user)
    }
}
