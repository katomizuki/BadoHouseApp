import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import RxGesture
import SDWebImage
// swiftlint:disable weak_delegate
protocol UserPageFlow {
    func toMyLevel()
    func toDismiss()
}

final class UserPageController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var coordinator: UserPageFlow?
    @IBOutlet private weak var userInfoTableView: UITableView!
    @IBOutlet private weak var scrollView: UIView!
    @IBOutlet private weak var racketView: UIView! {
        didSet { racketView.changeCorner(num: 8) }
    }
    @IBOutlet private weak var playerView: UIView! {
        didSet { playerView.changeCorner(num: 8) }
    }
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet { userImageView.changeCorner(num: 45) }
    }
    @IBOutlet private weak var racketTextField: UITextField!
    @IBOutlet private weak var playerTextField: UITextField!
    @IBOutlet private weak var userIntroductionTextView: UITextView! {
        didSet { userIntroductionTextView.changeCorner(num: 8) }
    }
    @IBOutlet private weak var nameTextField: UITextField!
    private let viewModel = UpdateUserInfoViewModel(userAPI: UserService())
    private lazy var dataSourceDelegate = UserPageDataSourceDelegate(viewModel: viewModel)
    private let imagePicker = UIImagePickerController()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTableView()
        setupNavigationBarItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerTextField.setUnderLine(width: playerView.frame.width)
        racketTextField.setUnderLine(width: racketView.frame.width)
    }
    
    private func setupNavigationBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapDismissButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
    }
    
    @objc private func didTapDismissButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        viewModel.inputs.saveUser()
    }
    
    // MARK: - SetupMethod
    private func setupTableView() {
        userInfoTableView.delegate = dataSourceDelegate
        userInfoTableView.dataSource = dataSourceDelegate
        dataSourceDelegate.delegate = self
        userInfoTableView.register(UITableViewCell.self, forCellReuseIdentifier: R.cellId)
        imagePicker.delegate = self
    }
    
    private func setupBinding() {
        userImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok, alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.userSubject.subscribe(onNext: { [weak self] user in
            self?.nameTextField.text = user.name
            self?.racketTextField.text = user.racket
            self?.playerTextField.text = user.player
            self?.userIntroductionTextView.text = user.introduction
            self?.userImageView.sd_setImage(with: user.profileImageUrl)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe { [weak self] _ in
            self?.userInfoTableView.reloadData()
        }.disposed(by: disposeBag)
        
        userIntroductionTextView.rx.text.asDriver().drive { [weak self] text in
            self?.viewModel.inputs.textViewInputs.onNext(text ?? "")
        }.disposed(by: disposeBag)
        
        nameTextField.rx.text.asDriver().drive { [weak self] text in
            self?.viewModel.inputs.nameTextFieldInputs.onNext(text ?? "")
        }.disposed(by: disposeBag)
        
        racketTextField.rx.text.asDriver().drive { [weak self] text in
            self?.viewModel.inputs.racketTextFieldInputs.onNext(text ?? "")
        }.disposed(by: disposeBag)
        
        playerTextField.rx.text.asDriver().drive { [weak self] text in
            self?.viewModel.inputs.playerTextFieldInputs.onNext(text ?? "")
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isCompleted.subscribe { [weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
// MARK: - ImagePickerDelegate
extension UserPageController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            userImageView.image = image
            viewModel.userImage = image
            viewModel.isChangeImage = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserPageController: UserPageDataSourceDelegateProtocol {
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc: UserLevelController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(_ vc: MyPageInfoPopoverController) {
        present(vc, animated: true)
    }
}
