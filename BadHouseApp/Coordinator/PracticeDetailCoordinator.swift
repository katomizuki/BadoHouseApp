//
//  PracticeDetaiCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import UIKit
class PracticeDetailCoordinator:Coordinator,PracticeDetailFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = PracticeDetailController.init(nibName: "PracticeDetailController", bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
