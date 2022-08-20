//
//  AuthRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol AuthRepositry {
    func register(credential: Domain.AuthCredential) -> Single<[String: Any]>
}
