//
//  LevelDetailCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
////
//
//import UIKit
//class LevelDetailCoordinator: Coordinator ,LevelDetailFlow{
//    let viewController:UIViewController
//    init(viewController:UIViewController) {
//        self.viewController = viewController
//    }
//    func start() {
//        let controller = LevelDetailController.init(nibName: R.nib.levelDetailController.name, bundle: nil)
//        controller.coordinator = self
//        viewController.present(controller, animated: true)
//    }
//    func dismiss() {
//        let controller = LevelDetailController.init(nibName: R.nib.levelDetailController.name, bundle: nil)
//        controller.coordinator = self
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
