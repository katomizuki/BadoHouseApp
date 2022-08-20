//
//  File.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol CircleRepositry {
    func getMembers(ids: [String], circle: Domain.CircleModel) -> Single<Domain.CircleModel>
    func searchCircles(text: String) -> Single<[Domain.CircleModel]>
    func updateCircle(circle: Domain.CircleModel) -> Completable
    func getCircle(id: String) -> Single<Domain.CircleModel>
    func postCircle(id: String,
                    dic: [String: Any],
                    user: Domain.UserModel,
                    memberId: [String],
                    completion: @escaping (Result<Void, Error>) -> Void)
    func withdrawCircle(user: Domain.UserModel,
                        circle: Domain.CircleModel) -> Completable
    func inviteCircle(ids: [String],
                      circle: Domain.CircleModel,
                      completion: @escaping (Result<Void, Error>) -> Void)
}
