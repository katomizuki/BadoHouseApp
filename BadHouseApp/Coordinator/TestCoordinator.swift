import Foundation
import UIKit

class TestCoordinator: Coordinator {
    let navigationController: UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        print("sss")
        let controller = TestController.init(nibName: "TestController", bundle: nil)
        controller.coordinator = self
        self.navigationController.pushViewController(controller, animated: true)
    }
}
