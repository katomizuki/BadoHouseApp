import Firebase

public struct PreJoined: Equatable {
    
    public let id: String
    public let circleImage: String
    public let createdAt: Timestamp
    public let fromUserId: String
    public let imageUrl: String
    public let name: String
    public let practiceName: String
    public let uid: String
    public var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    public init(id: String,
                circleImage: String,
                createdAt: Timestamp,
                fromUserId: String,
                imageUrl: String,
                name: String,
                practiceName: String,
                uid: String) {
        self.id = id
        self.circleImage = circleImage
        self.createdAt = createdAt
        self.fromUserId = fromUserId
        self.imageUrl = imageUrl
        self.name = name
        self.uid = uid
        self.practiceName = practiceName
    }
}

