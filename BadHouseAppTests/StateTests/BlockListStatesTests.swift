//
//  StateTests.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/15.
//

import ReSwift
@testable import BadHouseApp
import Quick
import Nimble

class BlockListStatesTests: QuickSpec {
    
    override func spec() {
        let appStore = Store(reducer: appReduce, state: AppState())
        
        let beforeReload = appStore.state.blockListState.reloadStatus
        let beforeUsers = appStore.state.blockListState.users
        
        describe("Block list State") {
            context("before state") {
                it("reload false") {
                    expect(beforeReload).to(beTrue())
                }
                it("users haveCount 0") {
                    expect(beforeUsers).to(haveCount(0))
                }
            }
            
            appStore.dispatch(BlockListState.BlockListAction.setUsers([User(dic: ["":""])]))
            appStore.dispatch(BlockListState.BlockListAction.changeReloadStatus(true))
            
            let afterReload = appStore.state.blockListState.reloadStatus
            let afterUsers = appStore.state.blockListState.users
            
            context("after state") {
                it("reload true") {
                    expect(afterReload).to(beTrue())
                }
                it("users haveCount 0") {
                    expect(afterUsers).to(haveCount(1))
                }
            }
        }
    }

}
