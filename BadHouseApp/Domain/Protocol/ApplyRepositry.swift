//
//  ApplyRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol ApplyRepositry {
    func getApplyUser(user: Domain.UserModel)->Single<[Domain.ApplyModel]>
    func getApplyedUser(user: Domain.UserModel)->Single<[Domain.ApplyedModel]>
    func match(user: Domain.UserModel,
               friend: Domain.UserModel) -> Completable
    func postApply(user: Domain.UserModel,
                   toUser: Domain.UserModel) -> Completable
    func notApplyFriend(uid: String,
                        toUserId: String)
}
