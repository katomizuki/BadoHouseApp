import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import RxGesture
protocol UserPageFlow {
    func toMyLevel()
    func toDismiss()
}
final class UserPageController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let cellId = "cellId"
    var coordinator: UserPageFlow?
    @IBOutlet private weak var userInfoTableView: UITableView!
    @IBOutlet private weak var scrollView: UIView!
    @IBOutlet private weak var racketView: UIView! {
        didSet {
            racketView.changeCorner(num: 8)
        }
    }
    @IBOutlet private weak var playerView: UIView! {
        didSet {
            playerView.changeCorner(num: 8)
        }
    }
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.changeCorner(num: 45)
        }
    }
    private let imagePicker = UIImagePickerController()
    @IBOutlet private weak var racketTextField: UITextField!
    @IBOutlet private weak var playerTextField: UITextField!
    @IBOutlet private weak var userIntroductionTextView: UITextView! {
        didSet {
            userIntroductionTextView.changeCorner(num: 8)
        }
    }
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
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapDismissButton))
        navigationItem.leftBarButtonItem = dismissButton
    }
    @objc private func didTapDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - SetupMethod
    private func setupTableView() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        userInfoTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        imagePicker.delegate = self
    }
    private func setupBinding() {
        print(#function)
        userImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }.disposed(by: disposeBag)
    }
}
// MARK: - ImagePickerDelegate
extension UserPageController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            userImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: UITableViewDelegate
extension UserPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserInfoSelection(rawValue: indexPath.row) == .level {
            coordinator?.toMyLevel()
        }
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
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
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDatasource
extension UserPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfoSelection.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellId)
        cell.textLabel?.text = UserInfoSelection(rawValue: indexPath.row)?.description
        cell.selectionStyle = .none
        return cell
    }
}
// MARK: - PopDismissDelegate
extension UserPageController: PopDismissDelegate {
    func popDismiss(vc: MyPageInfoPopoverController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UIPopoverPresentationControllerDelegate
extension UserPageController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
