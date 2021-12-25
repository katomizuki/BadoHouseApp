//
//  EventAdditionlItemsCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit
class EventAdditionlItemsCoordinator:Coordinator,EventAdditionlItemsFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = EventAdditionlItemsController.init(nibName: R.nib.eventAdditionlItemsController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
