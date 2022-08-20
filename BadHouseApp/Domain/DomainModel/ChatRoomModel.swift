import Firebase
import Foundation

public struct ChatRoom: Equatable {
    
    public let id: String
    public let latestMessage: String
    public let latestTimeString: String
    public let partnerName: String
    public let partnerUrlString: String
    public var userId: String
    
    public init(id: String,
         latestMessage: String,
         latestTimeString: String,
         partnerName: String,
         partnerUrlString: String,
         userId: String) {
        self.id = id
        self.latestTimeString = latestTimeString
        self.latestMessage = latestMessage
        self.partnerName = partnerName
        self.partnerUrlString = partnerUrlString
        self.userId = userId
    }
    public var partnerUrl: URL? {
        if let url = URL(string: partnerUrlString) {
            return url
        } else {
            return nil
        }
    }
 
}

