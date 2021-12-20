//
//  AddtionalPracticeElementCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit

class AddtionalPracticeElementCoordinator:Coordinator,AddtionalPracticeElementFlow {
  
    let navigationController:UINavigationController
    var viewController:AdditionalEventElementController?
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = AdditionalEventElementController.init(nibName: "AdditionalEventElementController", bundle: nil)
        self.viewController = controller
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext() {
        coordinator(to: EventAdditionlItemsCoordinator(navigationController: self.navigationController))
    }
    func toAddtionalPlace() {
        coordinator(to: AdditionalPlaceCoordinator(viewController: viewController!))
    }
}
