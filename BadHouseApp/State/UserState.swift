//
//  UserState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Foundation

struct UserState: StateType {
    var user: User?
    var userFriendsCountText = String()
    var userCircleCountText = String()
    var userUrl: URL?
    var friends = [User]()
    var circles = [Circle]()
    var isApplyViewHidden = false
    var errorStatus = false
    var reloadStatus = false
    var isAuth = false
}
