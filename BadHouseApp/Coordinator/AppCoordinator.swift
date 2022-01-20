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

        notificationNavigationController.tabBarItem = UITabBarItem(title: "お知らせ",
                        image: UIImage(systemName: "bell.fill"),
                        tag: 1)
        userNavigationController.tabBarItem =
        UITabBarItem(title: "ユーザー",
                     image: UIImage(systemName: "person.fill"),
                     tag: 2)
        talkNavigationController.tabBarItem = UITabBarItem(title: "トーク",
                        image:UIImage(systemName: "bubble.left.fill"),
                        tag: 3)
        mainNavigationController.tabBarItem =
        UITabBarItem(title: "ホーム",
                     image: UIImage(systemName: "homekit"),
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
