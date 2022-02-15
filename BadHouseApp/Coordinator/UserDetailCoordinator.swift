import UIKit

final class UserDetailCoordinator: Coordinator, MainUserDetailFlow {

    let navigationController: UINavigationController
    let viewModel: UserDetailViewModel
    
    init(navigationController: UINavigationController, viewModel: UserDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = MainUserDetailController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toFriendList(friends: [User], myData: User) {
        coordinator(to: FriendListCoordinator(navigationController: navigationController, viewModel: FriendsListViewModel(users: friends, myData: myData)))
    }
    
    func toCircleDetail(myData: User, circle: Circle) {
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController, viewModel: CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleRepositryImpl())))
    }
    
    func toChat(myData: User, user: User) {
        coordinator(to: ChatCoordinator(navigationController: navigationController, viewModel: ChatViewModel(myData: myData, user: user, userAPI: UserRepositryImpl(), chatAPI: ChatRepositryImpl())))
    }
}
