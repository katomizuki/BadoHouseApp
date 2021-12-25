
import UIKit

class HomeCoordinator: Coordinator,MainFlow {
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
        vc.present(controller, animated: true)
    }
    func toPracticeDetail() {
        coordinator(to: PracticeDetailCoordinator(navigationController: self.navigationController))
    }
    func toAuthentication(_ vc: UIViewController) {
        coordinator(to: RegisterCoordinator(navigationController: navigationController,
                                            viewController: vc))
       
    }
    
}
