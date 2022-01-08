
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
    func toMap(practices:[Practice],lat:Double, lon: Double) {
        
        let viewModel = MapListViewModel(currnetLatitude: lat, currentLongitude: lon, practices: practices)
        coordinator(to: MapCoordinator(navigationController: navigationController,viewModel:viewModel))
     
    }
    func toMakeEvent() {
        coordinator(to: MakePracticeCoordinator(navigationController: self.navigationController))
    }
    func toDetailSearch(_ vc: MainViewController, practices:[Practice]) {
        let controller = EventSearchController.init(viewModel: PracticeSearchViewModel(practiceAPI: PracticeServie(), practices: practices))
        controller.delegate = vc
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
                                               circleAPI: CircleService(), isModal: false)))
    }
    
}
