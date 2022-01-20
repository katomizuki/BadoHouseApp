//
//  ChatRoom.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/03.
//

import Firebase
import Foundation

struct ChatRoom: FirebaseModel {
    let id: String
    let latestMessage: String
    let latestTime: Timestamp
    let partnerName: String
    let partnerUrlString: String
    var userId: String
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.latestTime = dic["latestTime"] as? Timestamp ?? Timestamp()
        self.latestMessage = dic["latestMessage"] as? String ?? ""
        self.partnerName = dic["partnerName"] as? String ?? ""
        self.partnerUrlString = dic["partnerUrlString"] as? String ??  ""
        self.userId = dic["userId"] as? String ?? ""
    }
    var partnerUrl: URL? {
        if let url = URL(string: partnerUrlString) {
            return url
        } else {
            return nil
        }
    }
    var latestTimeString: String {
        let date = latestTime.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
}
