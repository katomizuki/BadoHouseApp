import Foundation
import FirebaseFirestore

public struct Notification: Equatable {
    
    public let id: String
    public let urlString: String
    public let notificationSelectionNumber: Int
    public var notificationSelection: NotificationEnum = .applyed
    public let titleText: String
    public let practiceId: String
    public let practiceTitle: String
    public let createdAt: Timestamp
    public var url: URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    
    public init(id: String,
                urlString: String,
                notificationSelectionNumber: Int,
                notificationSelection: NotificationEnum = .applyed,
                titleText: String,
                practiceId: String,
                practiceTitle: String ,
                createdAt: Timestamp) {
        self.id = id
        self.urlString = urlString
        self.notificationSelectionNumber = notificationSelectionNumber
        self.notificationSelection = notificationSelection
        self.titleText = titleText
        self.practiceId = practiceId
        self.practiceTitle = practiceTitle
        self.createdAt = createdAt
    }
    
}

