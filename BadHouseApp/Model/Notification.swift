//
//  Notification.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

struct Notification {
    let id: String
    let urlString: String
    let notificationSelectionNumber: Int
    var notificationSelection: NotificationEnum = .applyed
    let titleText: String
    init(dic:[String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.urlString = dic["urlString"] as? String ?? ""
        self.notificationSelectionNumber = dic["notificationSelectionNumber"] as? Int ?? 0
        switch self.notificationSelectionNumber {
        case 0: self.notificationSelection = .permissionFriend
        case 1: self.notificationSelection = .permissionJoin
        case 2: self.notificationSelection = .prejoined
        case 3: self.notificationSelection = .applyed
        default:break
        }
        self.titleText = dic["titleText"] as? String ?? ""
    }
    
}
