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
    let image: UIImage
    let circle: Circle
    let dic: [String:Any]
    init(navigationController:UINavigationController,
         dic: [String:Any],
         image: UIImage,
         circle: Circle) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.image = image
    }
    func start() {
        let controller = AdditionalEventElementController.init(nibName: R.nib.additionalEventElementController.name, bundle: nil)
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
