import UIKit

class UserCoordinator: Coordinator, UserFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = UserController.init(nibName: R.nib.userController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toSearchUser() {
        let controller = SearchUserController.init(nibName: "SearchUserController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toDetailUser() {
        let controller = MainUserDetailController.init(nibName: R.nib.mainUserDetailController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toDetailCircle() {
        let controller = CircleDetailController.init(nibName: R.nib.circleDetailController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toSearchCircle() {
        let controller = CircleSearchController.init(nibName: R.nib.circleSearchController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toMyPage(_ vc: UIViewController) {
        let controller = UserPageController.init(nibName: R.nib.userPageController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    func toMakeCircle() {
        let controller = MakeCircleController.init(nibName: R.nib.makeCircleController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toSettings(_ vc: UIViewController) {
        let controller = UserSettingsController.init(nibName: R.nib.userSettingsController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav,animated: true)
    }
    func toSchedule(_ vc: UIViewController) {
        let controller = ScheduleController.init(nibName:"ScheduleController", bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        vc.present(controller, animated: true, completion: nil)
    }
}
