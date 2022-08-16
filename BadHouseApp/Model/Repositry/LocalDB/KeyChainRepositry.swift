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
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "myId") as? String else { return Keychain(service: "") }
        return Keychain(service: identifier)
    }
    
    static var myId: String? {
        do {
            return try KeyChainRepositry.keychain.get("myId")
        } catch {
            return nil
        }
    }
    
    static func save(id: String) {
        do {
            try? keychain.set(id, key: "myId")
        } catch {
            print(error.localizedDescription)
        }
    }
}
