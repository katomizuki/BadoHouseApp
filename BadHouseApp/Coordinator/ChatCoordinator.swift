//
//  ChatCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
final class ChatCoordinator: Coordinator {
    let navigationController:UINavigationController
    let viewModel:ChatViewModel
    init(navigationController:UINavigationController,viewModel:ChatViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    func start() {
        let controller = CircleChatController.init(nibName: R.nib.circleChatController.name, bundle: nil)
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
}
