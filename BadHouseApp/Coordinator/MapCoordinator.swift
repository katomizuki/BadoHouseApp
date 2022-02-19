import UIKit

final class MapCoordinator: Coordinator, MapListFlow {
    
    let navigationController: UINavigationController
    let viewModel: MapListViewModel
    
    init(navigationController: UINavigationController, viewModel: MapListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = MapListController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func halfModal(_ practice: Practice, _ vc: MapListController) {
    let controller = PracticeDetailController.init(
        viewModel: PracticeDetailViewModel(
            practice: practice,
            isModal: true,
            store: appStore,
            actionCreator: PracticeActionCreator(
                userAPI: UserRepositryImpl(),
                circleAPI: CircleRepositryImpl(),
                joinAPI: JoinRepositryImpl())))
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        }
        vc.present(controller, animated: true)
    }
}
