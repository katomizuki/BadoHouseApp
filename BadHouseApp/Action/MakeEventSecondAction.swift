//
//  MakeEventSecondAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

extension MakeEventSecondState {
    enum MakeEventSecondAction: ReSwift.Action {
        case setCircle(_ circles: [Circle])
        case setUser(_ user: User)
    }
}
