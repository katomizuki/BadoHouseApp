import Firebase
import Domain

struct PreJoined: Equatable, FirebaseModel {
    typealias DomainModel = Domain.PreJoined
    let id: String
    let circleImage: String
    let createdAt: Timestamp
    let fromUserId: String
    let imageUrl: String
    let name: String
    let practiceName: String
    let uid: String
    var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.circleImage = dic["circleImage"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.fromUserId = dic["fromUserId"] as? String ?? String()
        self.imageUrl = dic["imageUrl"] as? String ?? String()
        self.name = dic["name"] as? String ?? String()
        self.practiceName = dic["practiceName"] as? String ?? String()
        self.uid = dic["uid"] as? String ?? String()
    }
    
    func convertToModel() -> Domain.PreJoined {
        return Domain.PreJoined(id: self.id,
                                circleImage: self.circleImage,
                                createdAt: self.createdAt,
                                fromUserId: self.fromUserId,
                                imageUrl: self.imageUrl,
                                name: self.name,
                                practiceName: self.practiceName,
                                uid: self.uid)
    }
}
