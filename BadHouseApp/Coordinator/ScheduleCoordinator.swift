//
//  ScheduleCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/07.
//

import UIKit

final class ScheduleCoordinator:Coordinator,ScheduleFlow {
   
    let navigationController:UINavigationController
    let viewModel:ScheduleViewModel
    let vc:UIViewController
    init(navigationController:UINavigationController,viewModel:ScheduleViewModel,vc:UIViewController) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.vc = vc
    }
    func start() {
        let controller = ScheduleController.init(viewModel: viewModel)
        controller.coordinator = self
        self.navigationController.setViewControllers([controller], animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        vc.present(navigationController, animated: true, completion: nil)
    }
    
    func toDetail(_ practice: Practice) {
        navigationController.pushViewController(PracticeDetailController.init(viewModel: PracticeDetailViewModel(practice: practice,
                                    userAPI: UserService(),
                                    circleAPI: CircleService(),
                                    isModal: true))
, animated: true)
    }
}

