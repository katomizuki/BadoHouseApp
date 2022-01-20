import UIKit

final class RegisterCoordinator: Coordinator, RegisterFlow {
    let navigationController: UINavigationController
    let viewController: UIViewController
    init(navigationController: UINavigationController,
         viewController: UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    
    func start() {
        let controller = RegisterController.init(nibName: R.nib.registerController.name, bundle: nil)
        self.navigationController.setViewControllers([controller], animated: true)
        controller.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func toLogin() {
        coordinator(to: LoginCoordinator(navigationController: navigationController))
    }
    
    func toMain() {
        viewController.dismiss(animated: true)
    }
}
