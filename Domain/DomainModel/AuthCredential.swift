//
//  AuthCredential.swift
//  Domain
//
//  Created by ミズキ on 2022/08/19.
//

public struct AuthCredential {
    public let name: String
    public let email: String
    public let password: String
    public init(name: String,
                email: String,
                password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
