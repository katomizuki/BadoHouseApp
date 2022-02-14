//
//  MainAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
extension HomeState {
    enum HomeStateAction: ReSwift.Action {
        case setPractices(_ practies: [Practice])
    }
}
