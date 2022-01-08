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
        let controller = PracticeDetailController.init(nibName: R.nib.practiceDetailController.name, bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail(myData: User, user: User) {
        let viewModel = UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: viewModel))
    }
    func toChat(myData: User, user: User) {
        coordinator(to: ChatCoordinator(navigationController: navigationController, viewModel: ChatViewModel(myData: myData, user: user, userAPI: UserService(), chatAPI: ChatService())))
    }
    func toCircleDetail(myData:User,circle:Circle) {
        let viewModel = CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())
        coordinator(to: CircleDetailCoordinator(navigationController: self.navigationController, viewModel: viewModel))
    }
}
