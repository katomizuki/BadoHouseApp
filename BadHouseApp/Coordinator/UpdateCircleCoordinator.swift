//
//  UpdateCircleCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/30.
//

import UIKit
class UpdateCircleCoordinator:Coordinator {
    let navigationController:UINavigationController
    let viewModel:UpdateCircleViewModel
    init(navigationController:UINavigationController,viewModel:UpdateCircleViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = UpdateCircleController.init(nibName: "UpdateCircleController", bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
}
