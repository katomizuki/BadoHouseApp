import UIKit

final class AddtionalEventLevelCoordinator: Coordinator, AddtionalEventLevelFlow {
   
    let navigationController: UINavigationController
    let title: String
    let image: UIImage
    let kind: String
    
    init(navigationController: UINavigationController, title: String, image: UIImage, kind: String) {
        self.navigationController = navigationController
        self.title = title
        self.image = image
        self.kind = kind
    }
    
    func start() {
        let controller = AddtionalEventLevelController.init(
            viewModel: MakeEventSecondViewModel(
                title: title,
                image: image,
                kind: kind,
                store: appStore,
                actionCreator: MakeEventSecondActionCreator(
                    userAPI: UserRepositryImpl())))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toNext(image: UIImage, dic: [String: Any], circle: Circle, user: User) {
        coordinator(to: AddtionalPracticeElementCoordinator(navigationController: self.navigationController, dic: dic,
                                       image: image,
                                       circle: circle,
                                       user: user))
    }
    
}
