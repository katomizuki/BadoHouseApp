import UIKit
import Domain
import Infra

final class UserDetailCoordinator: Coordinator, MainUserDetailFlow {

    let navigationController: UINavigationController
    let viewModel: UserDetailViewModel
    
    init(navigationController: UINavigationController,
         viewModel: UserDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = MainUserDetailController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toFriendList(friends: [Domain.UserModel],
                      myData: Domain.UserModel) {
        coordinator(to: FriendListCoordinator(navigationController: navigationController, viewModel: FriendsListViewModel(users: friends, myData: myData)))
    }
    
    func toCircleDetail(myData: Domain.UserModel,
                        circle: Domain.CircleModel) {
        coordinator(to: CircleDetailCoordinator(
            navigationController: navigationController,
            viewModel: CircleDetailViewModel(myData: myData,
                                             circle: circle,
                                             store: appStore,
                                             actionCreator:
                                                CircleDetailActionCreator(circleAPI: CircleRepositryImpl()))))
    }
    
    func toChat(myData: Domain.UserModel,
                user: Domain.UserModel) {
        coordinator(to: ChatCoordinator(
            navigationController: navigationController,
            viewModel: ChatViewModel(myData: myData,
                                     user: user,
                                     store: appStore,
                                     actionCreator:
                                        ChatActionCreator(chatAPI: ChatRepositryImpl(),
                                                          userAPI: UserRepositryImpl()))))
    }
}
