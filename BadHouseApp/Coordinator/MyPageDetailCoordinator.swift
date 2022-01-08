//
//  MyPageDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



final class MyPageDetailCoordinator:Coordinator,UserPageFlow {
    
    var navigationController: UINavigationController
    let viewController: UIViewController
    init(navigationController:UINavigationController,viewController:UIViewController) {
        self.navigationController = navigationController
        self.viewController = viewController
    }
    func start() {
        let controller = UserPageController.init(nibName: R.nib.userPageController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true)

    }
    func toMyLevel() {
    }
    func toDismiss() {
        
    }
}
