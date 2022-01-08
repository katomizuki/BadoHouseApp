//
//  CircleDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit

final class CircleDetailCoordinator:Coordinator,CircleDetailFlow {
    let navigationController:UINavigationController
    let viewModel:CircleDetailViewModel
    init(navigationController: UINavigationController,viewModel: CircleDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = CircleDetailController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail(user: User?, myData: User) {
        guard let user = user else {
            return
        }
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
    }
    func toInvite(circle: Circle, myData: User) {
        navigationController.pushViewController(AddtionalMemberController.init(viewModel: AdditionalMemberViewModel(user: myData, userAPI: UserService(), circle: circle)), animated: true)
    }
    func toUpdate(circle: Circle) {
        coordinator(to: UpdateCircleCoordinator(navigationController: navigationController, viewModel: UpdateCircleViewModel(circleAPI: CircleService(), circle: circle)))
    }
}
