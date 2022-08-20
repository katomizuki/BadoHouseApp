import UIKit
import Domain
import Infra

final class EventAdditionlItemsCoordinator: Coordinator, EventAdditionlItemsFlow {
    
    let navigationController: UINavigationController
    let image: UIImage
    let user: Domain.UserModel
    let dic: [String: Any]
    let circle: Domain.CircleModel
    
    init(navigationController: UINavigationController,
         image: UIImage,
         circle: Domain.CircleModel,
         user: Domain.UserModel,
         dic: [String: Any]) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.user = user
        self.image = image
    }
    
    func start() {
        let controller = EventAdditionlItemsController.init(
            viewModel: EventAdditionalItemViewModel(image: image,
                                         circle: circle,
                                         user: user,
                                         dic: dic,
                                         practiceAPI: PracticeRepositryImpl(),
                                                    store: appStore,
                                                    actionCreator: EventAdditionlItemsActionCreator()))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
