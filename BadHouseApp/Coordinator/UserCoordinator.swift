import UIKit

final class UserCoordinator: Coordinator, UserFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = UserController.init(viewModel: UserViewModel(userAPI: UserService(), applyAPI: ApplyService(), circleAPI: CircleService()))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toSearchUser(user: User?) {
        guard let user = user else { return }
        coordinator(to: SearchUserCoordinator(navigationController: navigationController, viewModel: SearchUserViewModel(userAPI: UserService(), user: user, applyAPI: ApplyService())))
    }
    
    func toDetailUser(myData: User?, user: User?) {
        guard let user = user else { return }
        guard let myData = myData else { return }
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
    }
    
    func toDetailCircle(myData: User?, circle: Circle?) {
        guard let circle = circle else { return }
        guard let myData = myData else { return }
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController, viewModel: CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())))
    }
    
    func toSearchCircle(user: User?) {
        guard let user = user else { return }
        coordinator(to: SearchCircleCoordinator(navigationController: navigationController, viewModel: SearchCircleViewModel(circleAPI: CircleService(), user: user)))
    }
    
    func toMyPage(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: UserPageController.init(viewModel: UpdateUserInfoViewModel(userAPI: UserService())))
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    
    func toMakeCircle(user: User?) {
        guard let user = user else { return }
        MakeCicleCoordinator(navigationController: self.navigationController).start(user: user)
    }
    
    func toSettings(_ vc: UIViewController, user: User?) {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UserSettingsController.init(user: user))
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    
    func toSchedule(_ vc: UIViewController, user: User?) {
        guard let user = user else { return }
        coordinator(to: ScheduleCoordinator(navigationController: UINavigationController(), viewModel: ScheduleViewModel(userAPI: UserService(), practiceAPI: PracticeRepositryImpl(), user: user), vc: vc))
    }
    
    func toApplyUser(user: User?) {
        guard let user = user else { return }
            navigationController.pushViewController( ApplyFriendController.init(viewModel: ApplyFriendsViewModel(user: user, applyAPI: ApplyService())), animated: true)
    }
    
    func toApplyedUser(user: User?) {
        guard let user = user  else { return }
            navigationController.pushViewController(ApplyedUserListController.init(viewModel: ApplyedUserListViewModel(applyAPI: ApplyService(), user: user)), animated: true)
    }
    
    func toTodo() {
        coordinator(to: MyTaskCoordinator(navigationController: navigationController))
    }
}
