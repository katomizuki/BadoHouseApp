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
}
