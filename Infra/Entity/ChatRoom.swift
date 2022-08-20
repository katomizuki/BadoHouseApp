import Firebase
import Foundation
import Domain

struct ChatRoom: FirebaseModel {
    typealias DomainModel = Domain.ChatRoom
    
    
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
    
    func convertToModel() -> Domain.ChatRoom {
        return Domain.ChatRoom(id: self.id,
                               latestMessage: self.latestMessage,
                               latestTimeString: self.latestTimeString,
                               partnerName: self.partnerName,
                               partnerUrlString: self.partnerUrlString,
                               userId: self.userId)
    }
}
