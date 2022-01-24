import UIKit

final class HomeCoordinator: Coordinator, HomeFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomeViewController.init(viewModel: HomeViewModel(practiceAPI: PracticeServie()))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toMap(practices: [Practice], lat: Double, lon: Double) {
        coordinator(to: MapCoordinator(navigationController: navigationController,
                                       viewModel: MapListViewModel(currnetLatitude: lat,
                                                                   currentLongitude: lon,
                                                                   practices: practices)))
     
    }
    
    func toMakeEvent() {
        coordinator(to: MakePracticeCoordinator(navigationController: self.navigationController))
    }
    
    func toDetailSearch(_ vc: HomeViewController, practices: [Practice]) {
        let controller = PracticeSearchController.init(viewModel: PracticeSearchViewModel(practiceAPI: PracticeServie(), practices: practices))
        controller.delegate = vc
        let nav = UINavigationController(rootViewController: controller)
        vc.present(nav, animated: true)
    }

    func toAuthentication(_ vc: UIViewController) {
        coordinator(to: RegisterCoordinator(navigationController: UINavigationController(),
                                            viewController: vc))
       
    }
    
    func toPracticeDetail(_ practice: Practice) {
        coordinator(to: PracticeDetailCoordinator(
            navigationController: self.navigationController,
            viewModel: PracticeDetailViewModel(practice: practice,
                                               userAPI: UserService(),
                                               circleAPI: CircleService(),
                                               isModal: false,
                                               joinAPI: JoinService())))
    }
    
}
