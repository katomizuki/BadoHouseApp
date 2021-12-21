//
//  AddtionalEventLevelCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit

class AddtionalEventLevelCoordinator:Coordinator,AddtionalEventLevelFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = AddtionalEventLevelController.init(nibName: "AddtionalEventLevelController", bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext() {
        coordinator(to: AddtionalPracticeElementCoordinator(navigationController: self.navigationController))
    }
    func toLevel() {
        coordinator(to: LevelDetailCoordinator(viewController: self.navigationController))
    }
}