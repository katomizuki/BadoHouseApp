import RxRelay
import RxSwift

final class FriendsListViewModel {
    
    let usersRelay = BehaviorRelay<[User]>(value: [])
    let myData: User
    
    private var users = [User]()
    
    init(users: [User], myData: User) {
        self.users = users
        self.myData = myData
        usersRelay.accept(users)
    }
}
