//
//  MakeCircleCoordinator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import UIKit

final class MakeCicleCoordinator: Coordinator, MakeCircleFlow {
    let navigationController: UINavigationController
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    func toInvite(_ user:User,form: Form?) {
        guard let form = form else {
            return
        }
        let controller = InviteToCircleController.init(viewModel: InviteViewModel(userAPI: UserService(), user: user, form: form))
        navigationController.pushViewController(controller, animated: true)
    }
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func start() {
        
    }
    func start(user: User) {
        let controller = MakeCircleController.init(viewModel: TeamRegisterViewModel(user: user))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
