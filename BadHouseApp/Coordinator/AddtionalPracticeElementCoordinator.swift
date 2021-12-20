//
//  AddtionalPracticeElementCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit

class AddtionalPracticeElementCoordinator:Coordinator {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = AdditionalEventElementController.init(nibName: "AdditionalEventElementController", bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext() {
        
    }
    func toLevel() {
        
    }
}
