
import UIKit

class UserCoordinator: Coordinator,UserFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = UserController.init(nibName: "UserController", bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toSearchUser() {
        let controller = AccountSearchController.init(nibName: "AccountSearchController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toDetailUser() {
        let controller = MainUserDetailController.init(nibName: "MainUserDetailController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toDetailCircle() {
        let controller = CircleDetailController.init(nibName: "CircleDetailController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toSearchCircle() {
        let controller = CircleSearchController.init(nibName: "CircleSearchController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toMyPage(_ vc:UIViewController) {
        let controller = UserPageController.init(nibName: "UserPageController", bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        vc.present(controller, animated: true)
    }
    func toMakeCircle() {
        
    }
}
