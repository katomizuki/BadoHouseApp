//
//  RegisterCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit

final class RegisterCoordinator:Coordinator,RegisterFlow {
    let navigationController: UINavigationController
    let viewController: UIViewController
    init(navigationController: UINavigationController,
         viewController: UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    func start() {
        let controller = RegisterController.init(nibName: R.nib.registerController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        controller.coordinator = self
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true, completion: nil)
    }
    func toLogin() {
        
    }
}
