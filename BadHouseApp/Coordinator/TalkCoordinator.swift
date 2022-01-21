import UIKit

final class TalkCoordinator: Coordinator, TalkFlow {
   
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = TalkViewController.init(nibName: R.nib.talkViewController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toChat(userId: String, myDataId: String, chatId: String) {
        UserService.getUserById(uid: userId) { user in
            UserService.getUserById(uid: myDataId) { myData in
                self.coordinator(to: ChatCoordinator(navigationController: self.navigationController, viewModel: ChatViewModel(myData: myData,
                                                                        user: user,
                                                                        userAPI: UserService(),
                                                                        chatAPI: ChatService())))
            }
        }
    }
}
