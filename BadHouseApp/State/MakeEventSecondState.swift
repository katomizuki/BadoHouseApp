//
//  MakeEventSecondState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

struct MakeEventSecondState: StateType {
    var user: Domain.UserModel?
    var circle = [Domain.CircleModel]()
}
