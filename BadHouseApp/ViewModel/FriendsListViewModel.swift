import RxRelay
import RxSwift
import Domain

final class FriendsListViewModel {
    
    let usersRelay = BehaviorRelay<[Domain.UserModel]>(value: [])
    let myData: Domain.UserModel
    
    private var users = [Domain.UserModel]()
    
    init(users: [Domain.UserModel], myData: Domain.UserModel) {
        self.users = users
        self.myData = myData
        usersRelay.accept(users)
    }
}
