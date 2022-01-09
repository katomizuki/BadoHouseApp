//
//  PracticeDetaiCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import UIKit
class PracticeDetailCoordinator:Coordinator, PracticeDetailFlow {
    let navigationController: UINavigationController
    let viewModel:PracticeDetailViewModel
    init(navigationController: UINavigationController,viewModel:PracticeDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = PracticeDetailController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail(myData: User, user: User) {
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
    }
    func toChat(myData: User, user: User) {
        coordinator(to: ChatCoordinator(navigationController: navigationController, viewModel: ChatViewModel(myData: myData, user: user, userAPI: UserService(), chatAPI: ChatService())))
    }
    func toCircleDetail(myData: User,circle: Circle) {
        coordinator(to: CircleDetailCoordinator(navigationController: self.navigationController, viewModel: CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())))
    }
}
