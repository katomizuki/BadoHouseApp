//
//  MyPracticeDetail.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/03.
//

import UIKit

final class MyPracticeCoordinator: Coordinator, MyPracticeFlow {
    let navigationController: UINavigationController
    let viewModel: MyPracticeViewModel
    init(navigationController: UINavigationController, viewModel: MyPracticeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = MyPracticeController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toPracticeDetail(myData: User, practice: Practice) {
        navigationController.pushViewController(
            PracticeDetailController.init(
                viewModel: PracticeDetailViewModel(
                    practice: practice,
                    isModal: false,
                    store: appStore,
                    actionCreator:
                        PracticeActionCreator(
                            userAPI: UserRepositryImpl(),
                            circleAPI: CircleRepositryImpl(),
                            joinAPI: JoinRepositryImpl()),
                    myData: myData)),
                                                      animated: true)
    }
    
}
