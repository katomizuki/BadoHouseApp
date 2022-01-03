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
    func toFriendList(friends: [User],myData: User) {
        let viewModel = FriendsListViewModel(users: friends, myData: myData)
        coordinator(to: FriendListCoordinator(navigationController: navigationController, viewModel: viewModel))
    }
    func toCircleDetail(myData: User, circle: Circle) {
        let viewModel = CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController,viewModel: viewModel))
    }
    func toChat(myData: User, user: User) {
        coordinator(to: ChatCoordinator(navigationController: navigationController, viewModel: ChatViewModel(myData: myData, user: user, userAPI: UserService(), chatAPI: ChatService())))
    }
    
}
