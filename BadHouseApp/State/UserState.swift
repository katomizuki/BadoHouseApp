//
//  UserState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Foundation

struct UserState: StateType {
    var user: User? = nil
    var userFriendsCountText = String()
    var userCircleCountText = String()
    var userUrl: URL? = nil
    var friends = [User]()
    var circles = [Circle]()
    var isApplyViewHidden = false
    var errorStatus = false
    var reloadStatus = false
}
