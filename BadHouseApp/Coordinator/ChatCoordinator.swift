import UIKit
import Infra
import Domain

final class ChatCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let viewModel: ChatViewModel
    
    init(navigationController: UINavigationController,
         viewModel: ChatViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = CircleChatController.init(viewModel: viewModel,
                                                   coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
