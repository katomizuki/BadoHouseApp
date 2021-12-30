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
    init(navigationController:UINavigationController,viewModel:CircleDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = CircleDetailController.init(nibName: R.nib.circleDetailController.name, bundle: nil)
        controller.viewModel = viewModel
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail(user: User?, myData: User) {
        guard let user = user else {
            return
        }
        let viewModel = UserDetailViewModel(myData: myData, user: user, userAPI: UserService())
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: viewModel))
    }
    func toInvite(circle: Circle, myData: User) {
        let controller = AddtionalMemberController.init(nibName: "AddtionalMemberController", bundle: nil)
        controller.viewModel = AdditionalMemberViewModel(user: myData, userAPI: UserService(), circle: circle)
        navigationController.pushViewController(controller, animated: true)
    }
    func toUpdate(circle: Circle) {
        let viewModel = UpdateCircleViewModel(circleAPI: CircleService(), circle: circle)
        coordinator(to: UpdateCircleCoordinator(navigationController: navigationController, viewModel: viewModel))
    }
}
