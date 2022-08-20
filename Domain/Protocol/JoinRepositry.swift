//
//  JoinRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol JoinRepositry {
    func getPrejoin(userId: String)->Single<[PreJoin]>
    func getPreJoined(userId: String)->Single<[PreJoined]>
    func postMatchJoin(preJoined: PreJoined,
                       user: Domain.UserModel,
                       myData: Domain.UserModel) -> Completable

    func postPreJoin(user: Domain.UserModel,
                     toUser: Domain.UserModel,
                     practice: Practice) -> Completable
}
