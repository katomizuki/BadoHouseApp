//
//  FriendListCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
final class FriendListCoordinator:Coordinator,FriendListFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = FriendsListController.init(nibName: R.nib.friendsListController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail() {
//       coordinator(to: UserDetailCoordinator(navigationController: navigationController))
    }
}
