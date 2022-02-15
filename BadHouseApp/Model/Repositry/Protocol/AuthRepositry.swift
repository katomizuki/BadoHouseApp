//
//  AuthRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

protocol AuthRepositry {
    func register(credential: AuthCredential,
                  completion: @escaping(Result<[String: Any], Error>) -> Void)
}
