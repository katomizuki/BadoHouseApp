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
        coordinator(to: UserCoordinator(navigationController: navigationController))
        
    }
    func toDetailCircle() {
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController))
    }
    func toSearchCircle() {
        coordinator(to: SearchCircleCoordinator(navigationController: navigationController))
    }
    func toMyPage(_ vc: UIViewController) {
//        coordinator(to: MyPageDetailCoordinator(na))
        let controller = UserPageController.init(nibName: R.nib.userPageController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    func toMakeCircle() {
        coordinator(to: MakeCicleCoordinator(navigationController: self.navigationController))
    }
    func toSettings(_ vc: UIViewController) {
        let controller = UserSettingsController.init(nibName: R.nib.userSettingsController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav,animated: true)
    }
    func toSchedule(_ vc: UIViewController) {
        let controller = ScheduleController.init(nibName: "ScheduleController", bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true, completion: nil)
    }
}
