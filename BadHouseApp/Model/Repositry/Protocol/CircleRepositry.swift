//
//  File.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol CircleRepositry {
    func getMembers(ids: [String], circle: Circle) -> Single<Circle>
    func searchCircles(text: String) -> Single<[Circle]>
    func updateCircle(circle: Circle, completion: @escaping (Error?) -> Void)
    func getCircle(id: String)->Single<Circle>
    func postCircle(id: String,
                    dic: [String: Any],
                    user: User,
                    memberId: [String],
                    completion: @escaping (Result<Void, Error>) -> Void)
    func withdrawCircle(user: User,
                        circle: Circle,
                        completion: @escaping(Error?) -> Void)
    func inviteCircle(ids: [String],
                      circle: Circle,
                      completion: @escaping (Result<Void, Error>) -> Void)
}
