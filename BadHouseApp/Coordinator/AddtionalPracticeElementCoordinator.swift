import UIKit
import Domain
import Infra

final class AddtionalPracticeElementCoordinator: Coordinator, AddtionalPracticeElementFlow {

    let navigationController: UINavigationController
    var viewController: AdditionalEventElementController?
    let image: UIImage
    let circle: Domain.CircleModel
    let dic: [String: Any]
    let user: Domain.UserModel
    
    init(navigationController: UINavigationController,
         dic: [String: Any],
         image: UIImage,
         circle: Domain.CircleModel,
         user: Domain.UserModel) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.image = image
        self.user = user
    }
    
    func start() {
        let controller = AdditionalEventElementController.init(
            viewModel: MakeEventThirdViewModel(image: image, dic: dic, circle: circle, user: user),
            coordinator: self)
        self.viewController = controller
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toNext(image: UIImage,
                circle: Domain.CircleModel,
                user: Domain.UserModel,
                dic: [String: Any]) {
        coordinator(to:
                        EventAdditionlItemsCoordinator(
                            navigationController:
                                navigationController,
                            image: image,
                            circle: circle,
                            user: user,
                            dic: dic))
    }
    
    func toAddtionalPlace() {
        coordinator(to: AdditionalPlaceCoordinator(viewController: viewController!))
    }
}
