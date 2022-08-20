//
//  MakeEventSecondAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

extension MakeEventSecondState {
    enum MakeEventSecondAction: ReSwift.Action {
        case setCircle(_ circles: [Domain.CircleModel])
        case setUser(_ user: Domain.UserModel)
    }
}
