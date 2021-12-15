import UIKit

class AppCoordinator: Coordinator {
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

        notificationNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        userNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        talkNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 3)
        mainNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
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
