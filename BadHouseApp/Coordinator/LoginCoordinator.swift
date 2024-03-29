import UIKit
import Domain
import Infra

final class LoginCoordinator: Coordinator, LoginFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = LoginController.init(viewModel:
                                                LoginViewModel(store: appStore,
                                                               actionCreator: LoginActionCreator()))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toRegister() {
        navigationController.popViewController(animated: true)
    }
}
