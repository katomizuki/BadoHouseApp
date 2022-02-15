//
//  ApplyRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol ApplyRepositry {
    func getApplyUser(user: User)->Single<[Apply]>
    func getApplyedUser(user: User)->Single<[Applyed]>
    func match(user: User,
               friend: User,
               completion: @escaping(Result<Void, Error>) -> Void)
    func postApply(user: User,
                   toUser: User,
                   completion: @escaping(Result<Void, Error>) -> Void)
    func notApplyFriend(uid: String,
                        toUserId: String)
}
