//
//  CircleDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



final class CircleDetailCoordinator:Coordinator,CircleDetailFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = CircleDetailController.init(nibName: R.nib.circleDetailController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
