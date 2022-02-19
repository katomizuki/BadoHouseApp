import UIKit

final class TalkCoordinator: Coordinator, TalkFlow {
   
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = TalkViewController.init(viewModel: TalkViewModel(userAPI: UserRepositryImpl(), chatAPI: ChatRepositryImpl()))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toChat(userId: String, myDataId: String, chatId: String) {
        UserRepositryImpl.getUserById(uid: userId) { user in
            UserRepositryImpl.getUserById(uid: myDataId) { myData in
                self.coordinator(to: ChatCoordinator(
                    navigationController: self.navigationController,
                    viewModel: ChatViewModel(myData: myData,
                                             user: user,
                                             store: appStore,
                                             actionCreator:
                                                ChatActionCreator(chatAPI: ChatRepositryImpl(),
                                                                  userAPI: UserRepositryImpl()))))
            }
        }
    }
}
