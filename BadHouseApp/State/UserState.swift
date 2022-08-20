//
//  UserState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Foundation
import Domain

struct UserState: StateType {
    var user: Domain.UserModel?
    var userFriendsCountText = String()
    var userCircleCountText = String()
    var userUrl: URL?
    var friends = [Domain.UserModel]()
    var circles = [Domain.CircleModel]()
    var isApplyViewHidden = false
    var errorStatus = false
    var reloadStatus = false
    var isAuth = false
}
