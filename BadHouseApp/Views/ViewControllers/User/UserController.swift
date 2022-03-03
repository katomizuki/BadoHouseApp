import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
// swiftlint:disable weak_delegate

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
    private let viewModel: UserViewModel
    private lazy var dataSourceDelegate = UserDataSourceDelegate(viewModel: viewModel)

    var coordinator: UserFlow?
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        setupTableView()
        setupNavigationItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
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
            self?.showCDAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok, alertType: .warning)
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
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .systemBlue
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: R.SFSymbols.calendar), style: .done, target: self, action: #selector(didTapScheduleButton))
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image:
                                                                UIImage(systemName: R.SFSymbols.gear),
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(didTapSettingButton)),
                                              UIBarButtonItem(image:
                                                                UIImage(systemName: R.SFSymbols.list),
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(didTapTodoButton))]
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
    
    @objc private func didTapTodoButton() {
        coordinator?.toTodo()
    }
    
    private func setupTableView() {
        groupTableView.delegate = dataSourceDelegate
        groupTableView.dataSource = dataSourceDelegate
        dataSourceDelegate.delegate = self
        groupTableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        groupTableView.register(UserProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: UserProfileHeaderView.id)
        groupTableView.showsVerticalScrollIndicator = false
    }
}

extension UserController: UserDataSourceDelegateProtocol {
    
    func userDataSourceDelegate(toSearchUser user: User?) {
        coordinator?.toSearchUser(user: user)
    }
    
    func userDataSourceDelegate(toSearchCircle user: User?) {
        coordinator?.toSearchCircle(user: user)
    }
    
    func userDataSourceDelegate(toApplyUser user: User?) {
        coordinator?.toApplyUser(user: user)
    }
    
    func userDataSourceDelegate(toMakeCircle user: User?) {
        coordinator?.toMakeCircle(user: user)
    }
    
    func userDataSourceDelegate(toCircleDetail user: User?, circle: Circle) {
        coordinator?.toDetailCircle(myData: user, circle: circle)
    }
    
    func userDataSourceDelegate(toUserDetail myData: User?, user: User) {
        coordinator?.toDetailUser(myData: myData, user: user)
    }
}
