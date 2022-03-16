import UIKit

final class CircleDetailCoordinator: Coordinator, CircleDetailFlow {
    
    let navigationController: UINavigationController
    let viewModel: CircleDetailViewModel
    
    init(navigationController: UINavigationController, viewModel: CircleDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let controller = CircleDetailController.init(viewModel: viewModel,
                                                     coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toUserDetail(user: User?, myData: User) {
        guard let user = user else { return }
        coordinator(to: UserDetailCoordinator(
            navigationController: navigationController,
            viewModel: UserDetailViewModel(myData: myData,
                                           user: user,
                                           store: appStore,
                                           actionCreator:
                                            UserDetailActionCreator(
                                                userAPI: UserRepositryImpl(),
                                                applyAPI: ApplyRepositryImpl()))))
    }
    
    func toInvite(circle: Circle, myData: User) {
        navigationController.pushViewController(AddtionalMemberController.init(viewModel: AdditionalMemberViewModel(
            user: myData,
            circle: circle,
            store: appStore,
            actionCreator: AdditionalMemberActionCreator(
                userAPI: UserRepositryImpl(),
                circleAPI: CircleRepositryImpl()))), animated: true)
    }
    
    func toUpdate(circle: Circle) {
        coordinator(to: UpdateCircleCoordinator(
            navigationController: navigationController,
            viewModel: UpdateCircleViewModel(circle: circle,
                                             store: appStore,
                                             actionCreator:
                                                UpdateCircleActionCreator(circleAPI: CircleRepositryImpl()))))
    }
}
