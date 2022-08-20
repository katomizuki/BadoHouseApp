//
//  PracticeRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol PracticeRepositry {
    func getPractices()->Single<[Domain.Practice]>
    func postPractice(dic: [String: Any],
                      circle: Domain.CircleModel,
                      user: Domain.UserModel) -> Completable
}
