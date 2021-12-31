//
//  PracticeEntity.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

import Firebase

struct Practice {
    let addressName: String
    let circleId: String
    let circleName: String
    let circleUrlString: String
    let court: Int
    let gather: Int
    let kind: String
    let id: String
    let maxLevel: String
    let minLevel: String
    let placeName: String
    let price: String
    let latitude: Double
    let longitude: Double
    let finish: Timestamp
    let start: Timestamp
    let deadLine: Timestamp
    let title: String
    let urlString: String
    let userId: String
    let userName: String
    let userUrlString: String
    var circleUrl:URL? {
        if let url = URL(string: circleUrlString) {
            return url
        } else {
            return nil
        }
    }
    var userUrl:URL? {
        if let url = URL(string: userUrlString) {
            return url
        } else {
            return nil
        }
    }
    var mainUrl:URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    init(dic: [String: Any]) {
        self.addressName = dic["addressName"] as? String ?? ""
        self.circleId = dic["circleId"] as? String ?? ""
        self.circleName = dic["circleName"] as? String ?? ""
        self.circleUrlString = dic["circleUrlString"] as? String ?? ""
        self.court = dic["court"] as? Int ?? 0
        self.gather = dic["gather"] as? Int ?? 0
        self.kind = dic["kind"] as? String ?? ""
        self.id = dic["id"] as? String ?? ""
        self.maxLevel = dic["maxLevel"] as? String ?? ""
        self.minLevel = dic["minLevel"] as? String ?? ""
        self.placeName = dic["placeName"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.latitude = dic["latitude"] as? Double ?? 0.0
        self.longitude = dic["longitude"] as? Double ?? 0.0
        self.finish = dic["finish"] as? Timestamp ?? Timestamp()
        self.start = dic["start"] as? Timestamp ?? Timestamp()
        self.deadLine = dic["deadLine"] as? Timestamp ?? Timestamp()
        self.title = dic["title"] as? String ?? ""
        self.urlString = dic["urlString"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userUrlString = dic["userUrlString"] as? String ?? ""
    }
}
