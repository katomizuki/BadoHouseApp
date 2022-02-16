//
//  AuthRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol AuthRepositry {
    func register(credential: AuthCredential) -> Single<[String: Any]>
}
