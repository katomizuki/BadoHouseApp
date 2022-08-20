//
//  BlockListActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift
import Foundation
import Domain
import Infra

struct BlockListActionCreator {
    private let disposeBag = DisposeBag()

    func getBlockList(_ blockIds: [String]) {
        let group = DispatchGroup()
        var blockUsers = [Domain.UserModel]()
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
    
    func removeBlock(_ user: Domain.UserModel,
                     ids: [String],
                     blockList: [Domain.UserModel]) {
        var blockIds = ids
        blockIds.remove(value: user.uid)
        Infra.UserDefaultsRepositry.shared.saveToUserDefaults(element: blockIds, key: R.UserDefaultsKey.blocks)
        var list = blockList
        list.remove(value: user)
        appStore.dispatch(BlockListState.BlockListAction.setUsers(list))
        appStore.dispatch(BlockListState.BlockListAction.changeReloadStatus(true))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(BlockListState.BlockListAction.changeReloadStatus(false))
    }
    
}
