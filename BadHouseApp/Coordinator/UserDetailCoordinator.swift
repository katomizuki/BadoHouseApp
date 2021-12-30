//
//  UserDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
final class UserDetailCoordinator:Coordinator,MainUserDetailFlow {
    
    let navigationController: UINavigationController
    let viewModel:UserDetailViewModel
    init(navigationController: UINavigationController,viewModel:UserDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = MainUserDetailController.init(nibName: R.nib.mainUserDetailController.name, bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    func toFriendList() {
        coordinator(to: FriendListCoordinator(navigationController: navigationController))
    }
    func toCircleDetail() {
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController))
    }
    
}
