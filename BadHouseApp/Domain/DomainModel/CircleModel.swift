//
//  CircleModel.swift
//  Domain
//
//  Created by ミズキ on 2022/08/18.
//

import Foundation

public struct CircleModel: Equatable {

    public static func == (lhs: CircleModel, rhs: CircleModel) -> Bool {
        return lhs.id == rhs.id
    }
    
   
    public var id: String
    public var features: [String]
    public var time: String
    public var price: String
    public var place: String
    public var name: String
    public var member: [String]
    public var additionlText: String
    public var backGround: String
    public var icon: String
    public var members = [UserModel]()
    public var charts: ChartsObject?
    public var iconUrl: URL? {
        if let url = URL(string: icon) {
            return url
        } else {
            return nil
        }
    }
    public var backGroundUrl: URL? {
        if let url = URL(string: backGround) {
            return url
        } else {
            return nil
        }
    }
    
    public init(id: String,
                features: [String],
                time: String,
                price: String,
                place: String,
                name: String,
                memeber: [String],
                additionlText: String,
                backGround: String,
                icon: String) {
        self.id = id
        self.features = features
        self.time = time
        self.price = price
        self.place = place
        self.name = name
        self.member = memeber
        self.additionlText = additionlText
        self.backGround = backGround
        self.icon = icon
    }
    
    public struct ChartsObject {
        public let members: [UserModel]
        
        public init(members: [UserModel]) {
            self.members = members
        }
        
        public func makeGenderPer() -> [Int] {
            var (men, women, other) = (0, 0, 0)
            self.members.forEach {
                switch $0.gender {
                case "男性":men += 1
                case "女性":women += 1
                default: other += 1
                }
            }
            return [men, women, other]
        }
        
        public func makeLevelPer() -> [Int] {
            var (one, two, three, four, five, six, seven, eight, nine, ten) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
            self.members.forEach {
                switch $0.level {
                case "レベル1":one += 1
                case "レベル2":two += 1
                case "レベル3":three += 1
                case "レベル4":four += 1
                case "レベル5":five += 1
                case "レベル6":six += 1
                case "レベル7": seven += 1
                case "レベル8":eight += 1
                case "レベル9":nine += 1
                case "レベル10":ten += 1
                default: break
                }
            }
            return [one, two, three, four, five, six, seven, eight, nine, ten]
        }
    }
}
