//
//  FriendsListViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/30.
//

import RxRelay
import RxSwift

final class FriendsListViewModel {
    var usersRelay = BehaviorRelay<[User]>(value:[])
    private var users = [User]()
    var myData: User
    init(users: [User], myData:User) {
        self.users = users
        self.myData = myData
        usersRelay.accept(users)
    }
}
