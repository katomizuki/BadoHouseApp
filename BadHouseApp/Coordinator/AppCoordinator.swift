import UIKit

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        tabBarController.coordinator = self
        let notificationNavigationController = UINavigationController()
        let userNavigationController = UINavigationController()
        let talkNavigationController = UINavigationController()
        let mainNavigationController = UINavigationController()
        
        notificationNavigationController.tabBarItem = UITabBarItem(title: R.TabName.notification,image: UIImage(systemName: R.SFSymbols.bell),tag: 1)
        userNavigationController.tabBarItem =
        UITabBarItem(title: R.TabName.user,
                     image: UIImage(systemName: R.SFSymbols.person),
                     tag: 2)
        talkNavigationController.tabBarItem = UITabBarItem(title: R.TabName.talk,
                                                           image: UIImage(systemName: R.SFSymbols.bubble),
                        tag: 3)
        mainNavigationController.tabBarItem =
        UITabBarItem(title: R.TabName.home,
                     image: UIImage(systemName: R.SFSymbols.home),
                     tag: 0)
        
        let notificationCoordinator = NotificationCoordinator(navigationController: notificationNavigationController)
        let userCoordinator = UserCoordinator(navigationController: userNavigationController)
        let talkCoordinator = TalkCoordinator(navigationController: talkNavigationController)
        let mainCoordinator = HomeCoordinator(navigationController: mainNavigationController)
        
        tabBarController.viewControllers = [mainNavigationController,
                                            notificationNavigationController,
                                            talkNavigationController,
                                            userNavigationController]
    
        coordinator(to: notificationCoordinator)
        coordinator(to: mainCoordinator)
        coordinator(to: userCoordinator)
        coordinator(to: talkCoordinator)
        window.makeKeyAndVisible()
    }
}
