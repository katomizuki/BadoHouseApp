//
//  SearchUserCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

import UIKit

final class SearchUserCoordinator:Coordinator,SearchUserFlow {
    let navigationController:UINavigationController
    let viewModel:SearchUserViewModel
    init(navigationController:UINavigationController,viewModel:SearchUserViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = SearchUserController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail(_ user: User,_ myData: User) {
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
    }
}
