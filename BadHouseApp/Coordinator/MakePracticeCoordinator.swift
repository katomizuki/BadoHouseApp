//
//  MakePracticeCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



class MakePracticeCoordinator:Coordinator,AdditionalEventTitleFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = AdditionalEventTitleController.init(nibName: "AdditionalEventTitleController", bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext() {
        coordinator(to: AddtionalEventLevelCoordinator(navigationController: self.navigationController))
    }
}
