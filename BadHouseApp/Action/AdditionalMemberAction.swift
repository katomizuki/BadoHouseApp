//
//  AdditionalMemberAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//

import ReSwift
extension AdditionalMemberState {
    enum AdditionalMemberAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case setMember(_ members: [User])
        case changeCompledStatus(_ isCompletd: Bool)
    }
}
