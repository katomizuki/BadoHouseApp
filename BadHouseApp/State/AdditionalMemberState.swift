//
//  AdditionalMemberState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//

import ReSwift
import Domain
struct AdditionalMemberState: StateType {
    var members = [Domain.UserModel]()
    var errorStatus = false
    var completedStatus = false
}
