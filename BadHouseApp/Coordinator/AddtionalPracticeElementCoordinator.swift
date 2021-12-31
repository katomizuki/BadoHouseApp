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
    let user: User
    init(navigationController:UINavigationController,
         dic: [String:Any],
         image: UIImage,
         circle: Circle,
         user: User) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.image = image
        self.user = user
    }
    func start() {
        let viewModel = MakeEventThirdViewModel(image: image, dic: dic, circle: circle, user: user)
        let controller = AdditionalEventElementController.init(nibName: R.nib.additionalEventElementController.name, bundle: nil)
        self.viewController = controller
        controller.viewModel = viewModel
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toNext(image: UIImage, circle: Circle, user: User, dic: [String : Any]) {
        coordinator(to: EventAdditionlItemsCoordinator(navigationController: navigationController, image: image, circle: circle, user: user, dic: dic))
    }
    func toAddtionalPlace() {
        coordinator(to: AdditionalPlaceCoordinator(viewController: viewController!))
    }
}
