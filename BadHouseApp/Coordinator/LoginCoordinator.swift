//
//  LoginCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
final class LoginCoordinator:Coordinator,LoginFlow {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = LoginController.init(nibName: R.nib.loginController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toRegister() {
        navigationController.popViewController(animated: true)
    }
}
