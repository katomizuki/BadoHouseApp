//
//  KeyChainRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import KeychainAccess
import Foundation
struct KeyChainRepositry {
    static var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "friendsId") as? String else { return Keychain(service: "") }
        return Keychain(service: identifier)
    }
}
