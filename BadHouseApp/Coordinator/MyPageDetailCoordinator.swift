import UIKit

final class MyPageDetailCoordinator: Coordinator, UserPageFlow {
    
    var navigationController: UINavigationController
    let viewController: UIViewController
    
    init(navigationController: UINavigationController, viewController: UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    
    func start() {
        let controller: UserPageController = UserPageController.init(
            viewModel: UpdateUserInfoViewModel(store: appStore,
                                               actionCreator:
                                                UpdateUserInfoActionCreator(
                                                    userAPI: UserRepositryImpl())))
        let nav: UINavigationController = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true)
    }
    
    func toMyLevel() {
    }
    
    func toDismiss() {
        
    }
}
