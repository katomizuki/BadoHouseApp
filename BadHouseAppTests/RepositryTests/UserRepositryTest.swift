//
//  UserRepositryTest.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/11.
//

import RxSwift
@testable import BadHouseApp
import XCTest
import Quick
import Nimble
import ReSwift
class HomeViewModelTests: QuickSpec {
    override func spec() {
        let appStore = Store(reducer: appReduce, state: AppState())
        let viewModel = HomeViewModel(store: appStore, actionCreator: HomeActionCreator(practiceAPI: PracticeRepositryImpl()))
        
    }
}
