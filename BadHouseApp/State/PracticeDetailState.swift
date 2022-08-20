//
//  PracticeDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

struct PracticeDetailState: StateType {
    var errorStatus = false
    var completedStatus = false
    var buttonHidden = false
    var isTakePartInButton = false
    var user: Domain.UserModel?
    var circle: Domain.CircleModel?
    var myData: Domain.UserModel?
}
