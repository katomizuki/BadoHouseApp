//
//  ApplyFriendsState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//
import ReSwift
import Domain

struct ApplyFriendsState: StateType {
    var applies = [Domain.ApplyModel]()
    var reloadStatus = false
    var errorStatus = false
}
