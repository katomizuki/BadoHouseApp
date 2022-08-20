import UIKit
import Infra
import Domain

final class AdditionalPlaceCoordinator: Coordinator, AddtionalPlaceFlow {
    let viewController: AdditionalEventElementController
    
    init(viewController: AdditionalEventElementController) {
        self.viewController = viewController
    }
    
    func start() {
        let controller = AddtionalPlaceController(coordinator: self)
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = viewController
        viewController.present(controller, animated: true)
    }
    
    func dismiss() {
        let controller = AddtionalPlaceController(coordinator: self)
        controller.dismiss(animated: true)
    }
}
