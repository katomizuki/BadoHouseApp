//
//  MyTaskCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/13.
//

import UIKit

final class MyTaskCoordinator: Coordinator, MyTaskFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = MyTaskController(viewModel: MyTaskViewModel())
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
}
