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
        let controller = ScheduleController.init(nibName: "ScheduleController", bundle: nil)
        controller.viewModel = viewModel
        controller.coordinator = self
        self.navigationController.setViewControllers([controller], animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        vc.present(navigationController, animated: true, completion: nil)
    }
    
    func toDetail(_ practice: Practice) {
        let controller = PracticeDetailController.init(nibName: R.nib.practiceDetailController.name, bundle: nil)
        controller.viewModel = PracticeDetailViewModel(practice: practice,
                                                       userAPI: UserService(),
                                                       circleAPI: CircleService(),
                                                       isModal: true)
        navigationController.pushViewController(controller, animated: true)
    }
}

