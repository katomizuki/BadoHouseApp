
import UIKit

class HomeCoordinator: Coordinator,MainFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = MainViewController.init(nibName: "MainViewController", bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toMap() {
        let controller = MapListController.init(nibName: "MapListController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toMakeEvent() {
        coordinator(to: MakePracticeCoordinator(navigationController: self.navigationController))
    }
    func toDetailSearch(_ vc:UIViewController) {
        let controller = EventSearchController.init(nibName: "EventSearchController", bundle: nil)
        vc.present(controller, animated: true)
    }
    func toPracticeDetail() {
        coordinator(to: PracticeDetailCoordinator(navigationController: self.navigationController))
    }
    func toAuthentication(_ vc:UIViewController) {
        let vc = RegisterController.init(nibName: "RegisterController", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true, completion: nil)
    }
    
}