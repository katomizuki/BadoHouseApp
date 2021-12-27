//
//  MakeCircleCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



final class MakeCicleCoordinator: Coordinator, MakeCircleFlow {
    let navigationController: UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func toInvite() {
        print(#function,"⚡️")
        let controller = InviteToCircleController.init(nibName: R.nib.inviteToCircleController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func start() {
        print("🌂")
        let controller = MakeCircleController.init(nibName: R.nib.makeCircleController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
