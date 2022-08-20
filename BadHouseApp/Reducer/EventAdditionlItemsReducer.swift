//
//  EventAdditionlItemsReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/08.
//

import ReSwift

struct EventAdditionlItemsReducer {
    static func reducer(action: ReSwift.Action, state: EventAdditionlItemsState?) -> EventAdditionlItemsState {
        var state = state ?? EventAdditionlItemsState()
        guard let action = action as? EventAdditionlItemsState.EventAdditionlItemsAction else { return state }
       
        return state
    }
}
