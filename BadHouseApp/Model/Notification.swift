//
//  Notification.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

import Foundation
import Firebase
struct Notification:FirebaseModel {
    let id: String
    let urlString: String
    let notificationSelectionNumber: Int
    var notificationSelection: NotificationEnum = .applyed
    let titleText: String
    let practiceId: String
    let practiceTitle: String
    let createdAt:Timestamp
    var url: URL? {
        if let url = URL(string: urlString){
            return url
        } else {
            return nil
        }
    }
    init(dic:[String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.urlString = dic["urlString"] as? String ?? ""
        self.notificationSelectionNumber = dic["notificationSelectionNumber"] as? Int ?? 0
        switch self.notificationSelectionNumber {
        case 0: self.notificationSelection = .applyed
        case 1: self.notificationSelection = .prejoined
        case 2: self.notificationSelection = .permissionJoin
        case 3: self.notificationSelection = .permissionFriend
        default:break
        }
        self.titleText = dic["titleText"] as? String ?? ""
        self.practiceId = dic["practiceId"] as? String ?? ""
        self.practiceTitle = dic["practiceTitle"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
