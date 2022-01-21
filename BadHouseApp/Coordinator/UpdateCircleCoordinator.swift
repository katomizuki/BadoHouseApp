import UIKit

final class UpdateCircleCoordinator: Coordinator {
    let navigationController: UINavigationController
    let viewModel: UpdateCircleViewModel
    init(navigationController: UINavigationController, viewModel: UpdateCircleViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = UpdateCircleController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
