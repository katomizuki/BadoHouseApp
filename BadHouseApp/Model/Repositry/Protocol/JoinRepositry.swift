//
//  JoinRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol JoinRepositry {
    func getPrejoin(userId: String)->Single<[PreJoin]>
    func getPreJoined(userId: String)->Single<[PreJoined]>
    func postMatchJoin(preJoined: PreJoined,
                       user: User,
                       myData: User) -> Completable

    func postPreJoin(user: User,
                     toUser: User,
                     practice: Practice) -> Completable
}
