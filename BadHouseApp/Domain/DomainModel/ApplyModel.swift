import Foundation

public struct ApplyModel: Equatable {
    public let uid: String
    public let createdAt: String
    public let imageUrl: String
    public let name: String
    public let toUserId: String
    public var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    public init(uid: String,
                createdAt: String,
                imageUrl: String,
                name: String,
                toUserId: String) {
        self.uid = uid
        self.createdAt = createdAt
        self.imageUrl = imageUrl
        self.name = name
        self.toUserId = toUserId
    }
}

