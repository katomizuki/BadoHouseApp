//
//  UserDefaultsRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import Foundation
public struct UserDefaultsRepositry {
     static public let shared = UserDefaultsRepositry()
//    public init() { }
    public func saveToUserDefaults<T: Codable>(element: [T], key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(element)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    public func loadFromUserDefaults<T: Codable>(key: String) -> [T] {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return []
            }
            let decodeData = try decoder.decode([T].self, from: data)
            return decodeData
        } catch {
            print(error)
            return []
        }
    }
    
    public func deleteFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
