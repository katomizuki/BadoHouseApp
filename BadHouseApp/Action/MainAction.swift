//
//  MainAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
extension MainState {
    enum MainStateAction: ReSwift.Action {
        case setPractices(_ practies: [Practice])
    }
}
