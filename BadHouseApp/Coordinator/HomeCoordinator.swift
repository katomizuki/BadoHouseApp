import UIKit

final class HomeCoordinator: Coordinator, HomeFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomeViewController.init(viewModel:
                                                    HomeViewModel(
                                                        store: appStore,
                                                        actionCreator: HomeActionCreator(
                                                            practiceAPI: PracticeRepositryImpl())))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toMap(practices: [Practice], lat: Double, lon: Double, myData: User?) {
        guard let myData = myData else { return }
        coordinator(to: MapCoordinator(navigationController:
                                        navigationController,
                                       viewModel: MapListViewModel(currnetLatitude: lat,
                                                                   currentLongitude: lon,
                                                                   practices: practices,
                                                                   myData: myData)))
     
    }
    
    func toMakeEvent() {
        coordinator(to: MakePracticeCoordinator(navigationController: navigationController))
    }
    
    func toDetailSearch(_ vc: HomeViewController, practices: [Practice]) {
        let controller = PracticeSearchController.init(viewModel:
                                                        PracticeSearchViewModel(
                                                            practices: practices,
                                                            store: appStore,
                                                            actionCreator: PracticeSearchActionCreator()))
        controller.delegate = vc
        let nav = UINavigationController(rootViewController: controller)
        vc.present(nav, animated: true)
    }

    func toAuthentication(_ vc: UIViewController) {
        coordinator(to: RegisterCoordinator(navigationController: UINavigationController(),
                                            viewController: vc))
       
    }
    
    func toPracticeDetail(_ practice: Practice, myData: User?) {
        guard let myData = myData else { return }
        coordinator(to: PracticeDetailCoordinator(
            navigationController: self.navigationController,
            viewModel: PracticeDetailViewModel(practice: practice,
                                               isModal: true,
                                               store: appStore,
                                               actionCreator:
                                                PracticeActionCreator(
                                                    userAPI: UserRepositryImpl(),
                                                    circleAPI: CircleRepositryImpl(),
                                                    joinAPI: JoinRepositryImpl()),
                                               myData: myData)))
    }
    
}
