//
//  MapCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit



final class MapCoordinator:Coordinator, MapListFlow {
    let navigationController:UINavigationController
    let viewModel:MapListViewModel
    init(navigationController:UINavigationController,viewModel:MapListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = MapListController.init(nibName: R.nib.mapListController.name, bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    func halfModal(_ practice: Practice,_ vc:MapListController) {
        let viewModel = PracticeDetailViewModel(practice: practice, userAPI: UserService(), circleAPI: CircleService(), isModal: true)
        let controller = PracticeDetailController(nibName: R.nib.practiceDetailController.name, bundle: nil)
        controller.viewModel = viewModel
        if #available(iOS 15.0, *) {
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium(),.large()]
            }
        }
        vc.present(controller, animated: true)
    }
}
