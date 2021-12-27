//
//  SearchCircleCoordinaotr.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



class SearchCircleCoordinator:Coordinator {
    let navigationController:UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = CircleSearchController.init(nibName: R.nib.circleSearchController.name, bundle: nil)
        navigationController.pushViewController(controller, animated: true)
    }
}
