//
//  HomeStateTests.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/08.
//

import Quick
import Nimble
@testable import BadHouseApp

class HomeStateTests: QuickSpec {
    private let homeActionCreator = HomeActionCreator(practiceAPI: PracticeRepositryImpl())
    
    override func spec() {
        let homeState = HomeState()
        let state = HomeReducer.reducer(action: HomeState.HomeStateAction.changeReloadStatus(true), state: homeState)
        describe("Check HomeState Practice") {
            context("getPractice") {
                it("it true") {
                    expect(state.reloadStatus).to(equal(true))
                }
            }
        }
    }
}
