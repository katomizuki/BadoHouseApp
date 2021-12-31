
import UIKit

final class HomeCoordinator: Coordinator,MainFlow {
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = MainViewController.init(nibName: R.nib.mainViewController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toMap() {
        let controller = MapListController.init(nibName: R.nib.mapListController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toMakeEvent() {
        coordinator(to: MakePracticeCoordinator(navigationController: self.navigationController))
    }
    func toDetailSearch(_ vc: UIViewController) {
        let controller = EventSearchController.init(nibName: R.nib.eventSearchController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        vc.present(nav, animated: true)
    }

    func toAuthentication(_ vc: UIViewController) {
        coordinator(to: RegisterCoordinator(navigationController: UINavigationController(),
                                            viewController: vc))
       
    }
    func toPracticeDetail(_ practice: Practice) {
        coordinator(to:PracticeDetailCoordinator(
            navigationController: self.navigationController,
            viewModel: PracticeDetailViewModel(practice: practice,
                                               userAPI: UserService(),
                                               circleAPI: CircleService())))
    }
    
}
