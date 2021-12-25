
import UIKit

class TalkCoordinator: Coordinator,TalkFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = TalkViewController.init(nibName: R.nib.talkViewController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toChat() {
        coordinator(to: ChatCoordinator(navigationController: self.navigationController))
    }
}
