//
//  BlockListActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift
import Foundation

struct BlockListActionCreator {
    private let disposeBag = DisposeBag()

    func getBlockList(_ blockIds: [String]) {
        let group = DispatchGroup()
        var blockUsers = [User]()
        blockIds.forEach {
            group.enter()
            UserRepositryImpl.getUserById(uid: $0) { user in
                defer { group.leave() }
                blockUsers.append(user)
            }
        }
        group.notify(queue: .main) {
            appStore.dispatch(BlockListState.BlockListAction.setUsers(blockUsers))
            appStore.dispatch(BlockListState.BlockListAction.changeReloadStatus(true))
        }
    }
    
    func removeBlock(_ user: User, ids: [String],blockList: [User]) {
        var blockIds = ids
        blockIds.remove(value: user.uid)
        UserDefaultsRepositry.shared.saveToUserDefaults(element: blockIds, key: R.UserDefaultsKey.blocks)
        var list = blockList
        list.remove(value: user)
        appStore.dispatch(BlockListState.BlockListAction.setUsers(list))
        appStore.dispatch(BlockListState.BlockListAction.changeReloadStatus(true))
    }
    
}
