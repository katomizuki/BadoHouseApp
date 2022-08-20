//
//  MyPracticeAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

extension MyPracticeState {
    enum MyPracticeAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case setPractice(_ practices: [Domain.Practice])
    }
}
