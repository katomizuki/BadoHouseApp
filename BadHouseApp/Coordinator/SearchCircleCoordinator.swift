//
//  SearchCircleCoordinaotr.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit

class SearchCircleCoordinator:Coordinator, CircleSearchFlow {
    let navigationController:UINavigationController
    let viewModel:SearchCircleViewModel
    init(navigationController:UINavigationController,viewModel:SearchCircleViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = CircleSearchController.init(nibName: R.nib.circleSearchController.name, bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    func toCircleDetail(myData: User, circle:Circle?) {
        guard let circle = circle else {
            return
        }
        let viewModel = CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController, viewModel: viewModel))
    }
    
}
