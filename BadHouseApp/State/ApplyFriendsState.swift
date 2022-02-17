//
//  ApplyFriendsState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//
import ReSwift

struct ApplyFriendsState: StateType {
    var applies = [Apply]()
    var reloadStatus = false
    var errorStatus = false
}
