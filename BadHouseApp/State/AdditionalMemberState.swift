//
//  AdditionalMemberState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//

import ReSwift
struct AdditionalMemberState: StateType {
    var members = [User]()
    var errorStatus = false
    var completedStatus = false
}
