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
        let testNavigationController = UINavigationController()
        let notificationNavigationController = UINavigationController()
        let userNavigationController = UINavigationController()
        
        testNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        notificationNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        userNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        
        let notificationCoordinator = NotificationCoordinator(navigationController: notificationNavigationController)
        let testCoordinator = TestCoordinator(navigationController: testNavigationController)
        let userCoordinator = UserCoordinator(navigationController: userNavigationController)
    
        tabBarController.viewControllers = [testNavigationController,notificationNavigationController,userNavigationController]
    
        coordinator(to: notificationCoordinator)
        coordinator(to: testCoordinator)
        coordinator(to: userCoordinator)
        window.makeKeyAndVisible()
    }
}
