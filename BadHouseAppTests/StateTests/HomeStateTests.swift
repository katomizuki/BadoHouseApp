//
//  HomeStateTests.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/08.
//

import Quick
import Nimble
import ReSwift
@testable import BadHouseApp

class HomeStateTests: QuickSpec {
    private let homeActionCreator = HomeActionCreator(practiceAPI: PracticeRepositryImpl())
    private let sampleError = ErrorSample()
    
    struct ErrorSample: Error { }
    override func spec() {

        let user = User(dic: ["": ""])
        let practices = [Practice(dic: ["": ""]), Practice(dic: ["": ""])]
        let appStore = Store(reducer: appReduce, state: AppState())
        let beforeReload = appStore.state.homeState.reloadStatus
        let beforeError = appStore.state.homeState.errorStatus
        let beforePractice = appStore.state.homeState.practices
        let beforeUser = appStore.state.homeState.user
        let beforeIndicator = appStore.state.homeState.isIndicatorAnimating
        let beforeRefesh = appStore.state.homeState.isRefreshAnimating
        
        describe("Check HomeState") {
            context("before") {
                it("it user nil") {
                    expect(beforeUser).to(beNil())
                }
                it("it practices []") {
                    expect(beforePractice).to(haveCount(0))
                }
                it("it Indicator false") {
                    expect(beforeIndicator).to(beFalse())
                }
                it("it error nil") {
                    expect(beforeError).to(beNil())
                }
                it("it refresh false") {
                    expect(beforeRefesh).to(beFalse())
                }
                it("it reload false") {
                    expect(beforeReload).to(beFalse())
                }
            }
           
            // MARK: Action
            appStore.dispatch(HomeState.HomeStateAction.changeReloadStatus(true))
            appStore.dispatch(HomeState.HomeStateAction.changeRefreshStatus(true))
            appStore.dispatch(HomeState.HomeStateAction.changeIndicatorStatus(true))
            appStore.dispatch(HomeState.HomeStateAction.setPractices(practices))
            appStore.dispatch(HomeState.HomeStateAction.setUser(user))
            appStore.dispatch(HomeState.HomeStateAction.chageErrorStatus(sampleError))
                            
            let afterReload = appStore.state.homeState.reloadStatus
            let afterRefresh = appStore.state.homeState.isRefreshAnimating
            let afterIndicator = appStore.state.homeState.isIndicatorAnimating
            let afterPractices = appStore.state.homeState.practices
            let afterUser = appStore.state.homeState.user
            let afterError = appStore.state.homeState.errorStatus
            
            context("after") {
                it("it user not nil") {
                    expect(afterUser).notTo(beNil())
                }
                it("it practices count 2") {
                    expect(afterPractices).to(haveCount(2))
                }
                it("it Indicator true") {
                    expect(afterIndicator).to(beTrue())
                }
                it("it error nil") {
                    expect(afterError).notTo(beNil())
                }
                it("it refresh true") {
                    expect(afterRefresh).to(beTrue())
                }
                it("it reload true") {
                    expect(afterReload).to(beTrue())
                }
            }
        }
    }
}
