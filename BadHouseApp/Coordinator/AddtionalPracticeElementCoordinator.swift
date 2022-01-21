import UIKit

final class AddtionalPracticeElementCoordinator: Coordinator, AddtionalPracticeElementFlow {

    let navigationController: UINavigationController
    var viewController: AdditionalEventElementController?
    let image: UIImage
    let circle: Circle
    let dic: [String: Any]
    let user: User
    init(navigationController: UINavigationController,
         dic: [String: Any],
         image: UIImage,
         circle: Circle,
         user: User) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.image = image
        self.user = user
    }
    func start() {
        let controller = AdditionalEventElementController.init(viewModel: MakeEventThirdViewModel(image: image, dic: dic, circle: circle, user: user))
        self.viewController = controller
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext(image: UIImage, circle: Circle, user: User, dic: [String: Any]) {
        coordinator(to: EventAdditionlItemsCoordinator(navigationController: navigationController, image: image, circle: circle, user: user, dic: dic))
    }
    func toAddtionalPlace() {
        coordinator(to: AdditionalPlaceCoordinator(viewController: viewController!))
    }
}
