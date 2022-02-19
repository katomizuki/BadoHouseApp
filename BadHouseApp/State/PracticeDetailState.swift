//
//  PracticeDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct PracticeDetailState: StateType {
    var errorStatus = false
    var completedStatus = false
    var buttonHidden = false
    var isTakePartInButton = false
    var user: User?
    var circle: Circle?
    var myData: User?
}
