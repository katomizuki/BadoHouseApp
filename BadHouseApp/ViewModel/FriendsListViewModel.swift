import RxRelay
import RxSwift

final class FriendsListViewModel {
    
    let usersRelay = BehaviorRelay<[User]>(value: [])
    private var users = [User]()
    let myData: User
    
    init(users: [User], myData: User) {
        self.users = users
        self.myData = myData
        usersRelay.accept(users)
    }
}
