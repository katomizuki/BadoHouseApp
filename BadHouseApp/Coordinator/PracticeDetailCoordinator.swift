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
        let controller = PracticeDetailController.init(nibName: R.nib.practiceDetailController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail() {
        print(#function)
//        coordinator(to: User)
    }
    func toChat() {
        
    }
    func toCircleDetail() {
        coordinator(to: CircleDetailCoordinator(navigationController: self.navigationController))
    }
}
