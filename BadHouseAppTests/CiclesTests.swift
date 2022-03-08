//
//  BadHouseAppTests.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/02/21.
//

import XCTest
import Nimble
import Quick
@testable import BadHouseApp
class CiclesTests: QuickSpec {
    
    private var circle = Circle(dic: ["id": "sss",
                             "features": [],
                             "time": "",
                             "price": "都筑区スポーツセンター",
                             "place": "神奈川県",
                             "name": "加藤瑞樹",
                             "member": [],
                             "additionlText": "aiueo",
                             "backGround": "",
                             "icon": ""])
    
    override func spec() {
        let user = User(dic: ["level": "レベル4", "gender": "男性"])
        let user2 = User(dic: ["level": "レベル3", "gender": "女性"])
        let user3 = User(dic: ["level": "レベル3", "gender": "女性"])
        let user4 = User(dic: ["level": "レベル9", "gender": "その他"])
        self.circle.charts = Circle.ChartsObject(members: [user, user2, user3, user4])
        guard let charts = self.circle.charts else { return }
        let levels = charts.makeLevelPer()
        let genders = charts.makeGenderPer()
        describe("Circle Login") {
            context("when getLevelsArray") {
                it("it [0,0,2,1,0,0,0,0,1,0]") {
                    expect(levels).to(equal([0,0,2,1,0,0,0,0,1,0]))
                }
            }
            context("when getGenderArray") {
                it("it [1,2,0]") {
                    expect(genders).to(equal([1,2,1]))
                }
            }
        }
    }

}
