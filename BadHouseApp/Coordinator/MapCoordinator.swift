//
//  MapCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



final class MapCoordinator:Coordinator, MapListFlow {
    let navigationController:UINavigationController
    let viewModel: MapListViewModel
    init(navigationController: UINavigationController, viewModel: MapListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = MapListController.init(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func halfModal(_ practice: Practice,_ vc: MapListController) {
        let controller = PracticeDetailController.init(viewModel: PracticeDetailViewModel(practice: practice, userAPI: UserService(), circleAPI: CircleService(), isModal: true))
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium(),.large()]
            }
        }
        vc.present(controller, animated: true)
    }
}
