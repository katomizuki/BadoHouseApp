//
//  EventAdditionlItemsCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/20.
//

import UIKit
class EventAdditionlItemsCoordinator:Coordinator,EventAdditionlItemsFlow {
    let navigationController:UINavigationController
    let image: UIImage
    let user: User
    let dic: [String:Any]
    let circle: Circle
    init(navigationController:UINavigationController,
         image: UIImage, circle: Circle, user: User, dic: [String : Any]) {
        self.navigationController = navigationController
        self.dic = dic
        self.circle = circle
        self.user = user
        self.image = image
    }
    func start() {
        let controller = EventAdditionlItemsController.init(viewModel: EventAdditionalItemViewModel(image: image, circle: circle, user: user, dic: dic))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
