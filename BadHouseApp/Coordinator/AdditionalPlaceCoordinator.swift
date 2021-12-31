//
//  AdditionalPlaceCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit

class AdditionalPlaceCoordinator: Coordinator,AddtionalPlaceFlow {
    let viewController:AdditionalEventElementController
    init(viewController:AdditionalEventElementController) {
        self.viewController = viewController
    }
    func start() {
        let controller = AddtionalPlaceController.init(nibName: R.nib.addtionalPlaceController.name, bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = viewController
        controller.coordinator = self
        viewController.present(controller, animated: true, completion: nil)
    }
    func dismiss() {
        let controller = AddtionalPlaceController.init(nibName: R.nib.addtionalPlaceController.name, bundle: nil)
        controller.dismiss(animated: true, completion: nil)
    }
}
