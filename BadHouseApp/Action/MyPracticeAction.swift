//
//  MyPracticeAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

extension MyPracticeState {
    enum MyPracticeAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case setPractice(_ practices: [Practice])
    }
}
