//
//  PracticeDetailAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

extension PracticeDetailState {
    enum PracticeDetailAction: ReSwift.Action {
        case setUser(_ user: Domain.UserModel)
        case setCircle(_ circle: Domain.CircleModel)
        case changeErrorStatus(_ isError: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
        case changeButtonHiddenStatus(_ isButtonHidden: Bool)
        case changeTakePartInButtonStatus(_ isButtonHidden: Bool)
        case setMyData(_ user: Domain.UserModel)
    }
}
