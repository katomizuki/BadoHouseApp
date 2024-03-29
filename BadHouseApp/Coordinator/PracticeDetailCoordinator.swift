import UIKit
import Domain
import Infra

final class PracticeDetailCoordinator: Coordinator, PracticeDetailFlow {
    
    let navigationController: UINavigationController
    let viewModel: PracticeDetailViewModel
    
    init(navigationController: UINavigationController,
         viewModel: PracticeDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = PracticeDetailController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toUserDetail(myData: Domain.UserModel,
                      user: Domain.UserModel) {
        coordinator(to: UserDetailCoordinator(
            navigationController: navigationController,
            viewModel: UserDetailViewModel(myData: myData,
                                           user: user,
                                           store: appStore,
                                           actionCreator:
                                            UserDetailActionCreator(
                                                userAPI: UserRepositryImpl(),
                                                applyAPI: ApplyRepositryImpl()))))
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
    
    func toCircleDetail(myData: Domain.UserModel,
                        circle: Domain.CircleModel) {
        coordinator(to: CircleDetailCoordinator(
            navigationController: self.navigationController,
            viewModel: CircleDetailViewModel(myData: myData,
                                             circle: circle,
                                             store: appStore,
                                             actionCreator:
                                                CircleDetailActionCreator(circleAPI: CircleRepositryImpl()))))
    }
}
