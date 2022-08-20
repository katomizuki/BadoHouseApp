import Foundation
import FirebaseFirestore
import Domain

struct Notification: FirebaseModel {
    
    typealias DomainModel = Domain.Notification
    
    let id: String
    let urlString: String
    let notificationSelectionNumber: Int
    var notificationSelection: NotificationEnum = .applyed
    let titleText: String
    let practiceId: String
    let practiceTitle: String
    let createdAt: Timestamp
    var url: URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
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
    
    func convertToModel() -> Domain.Notification {
        let selection: Domain.NotificationEnum
        switch self.notificationSelection {
        case.applyed: selection = .applyed
        case .permissionFriend: selection = .permissionFriend
        case .prejoined: selection = .prejoined
        case .permissionJoin: selection = .permissionJoin
        }
        return Domain.Notification(id: self.id,
                                   urlString: self.urlString,
                                   notificationSelectionNumber: self.notificationSelectionNumber,
                                   notificationSelection: selection, titleText: self.titleText,
                                   practiceId: self.practiceId,
                                   practiceTitle: self.practiceTitle,
                                   createdAt: self.createdAt)
    }
    
}
