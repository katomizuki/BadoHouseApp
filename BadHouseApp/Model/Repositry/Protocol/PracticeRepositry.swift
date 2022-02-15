//
//  PracticeRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol PracticeRepositry {
    func getPractices()->Single<[Practice]>
    func postPractice(dic: [String: Any],
                      circle: Circle,
                      user: User,
                      completion: @escaping(Error?) -> Void)
}
