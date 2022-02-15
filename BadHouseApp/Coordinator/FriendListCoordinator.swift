import UIKit

final class FriendListCoordinator: Coordinator, FriendListFlow {
    
    let navigationController: UINavigationController
    let viewModel: FriendsListViewModel
    
    init(navigationController: UINavigationController, viewModel: FriendsListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = FriendsListController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toUserDetail(myData: User, user: User) {
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserRepositryImpl(), applyAPI: ApplyRepositryImpl())))
    }
}
