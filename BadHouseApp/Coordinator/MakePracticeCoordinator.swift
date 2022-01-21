import UIKit

final class MakePracticeCoordinator: Coordinator, AdditionalEventTitleFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = AdditionalEventTitleController.init(nibName: R.nib.additionalEventTitleController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toNext(title: String, image: UIImage, kind: String) {
        coordinator(to: AddtionalEventLevelCoordinator(navigationController: self.navigationController, title: title,
                                       image: image,
                                       kind: kind))
    }
}
