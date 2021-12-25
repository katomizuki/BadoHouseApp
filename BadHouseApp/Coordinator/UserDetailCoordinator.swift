//
//  UserDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
final class UserDetailCoordinator:Coordinator,MainUserDetailFlow {
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = MainUserDetailController.init(nibName: R.nib.mainUserDetailController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toFriendList() {
        coordinator(to: FriendListCoordinator(navigationController: navigationController))
    }
    func toCircleDetail() {
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController))
    }
    
}
