import UIKit

final class SearchCircleCoordinator: Coordinator, CircleSearchFlow {
    
    let navigationController: UINavigationController
    let viewModel: SearchCircleViewModel
    
    init(navigationController: UINavigationController, viewModel: SearchCircleViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = CircleSearchController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toCircleDetail(myData: User, circle: Circle?) {
        guard let circle = circle else { return }
        coordinator(to: CircleDetailCoordinator(
            navigationController: navigationController,
            viewModel: CircleDetailViewModel(myData: myData,
                                             circle: circle,
                                             circleAPI: CircleRepositryImpl(),
                                             store: appStore,
                                             actionCreator:
                                                CircleDetailActionCreator(circleAPI: CircleRepositryImpl()))))
    }
}
