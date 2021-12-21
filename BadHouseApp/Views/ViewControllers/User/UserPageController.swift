import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

protocol UserDismissDelegate: AnyObject {
    func userVCdismiss(vc: UserPageController)
}
final class UserPageController: UIViewController {
    // MARK: - Properties
    private let diposeBag = DisposeBag()
    weak var delegate: UserDismissDelegate?
    @IBOutlet private weak var scrollView: UIView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        setupBinding()
    }
    // MARK: - SetupMethod
    private func setupUI() {
        
    }
    private func setupBinding() {
        print(#function)
    }
   
 
}
// MARK: - ImagePickerDelegate
extension UserPageController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
//            profileImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: UITableViewDelegate
extension UserPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if cellTitleArray[indexPath.row] == UserInfo.level {
//            let controller = UserLevelController.init(nibName: "UserLevelController", bundle: nil)
//            controller.modalPresentationStyle = .fullScreen
//            present(controller, animated: true, completion: nil)
//        }
//        guard let cell = tableView.cellForRow(at: indexPath) else {
//            return
//        }
//        let viewController = MyPageInfoPopoverController()
//        viewController.modalPresentationStyle = .popover
//        viewController.preferredContentSize = CGSize(width: 200, height: 150)
//        viewController.delegate = self
//        let presentationController = viewController.popoverPresentationController
//        presentationController?.delegate = self
//        presentationController?.permittedArrowDirections = .up
//        presentationController?.sourceView = cell
//        presentationController?.sourceRect = cell.bounds
//        viewController.keyword = cellTitleArray[indexPath.row]
//        viewController.presentationController?.delegate = self
//        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDatasource
//extension UserPageController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cellTitleArray.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
//
//        return cell
//    }
//}
