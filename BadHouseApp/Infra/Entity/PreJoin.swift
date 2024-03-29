import Firebase
import Domain
struct PreJoin: Equatable, FirebaseModel {
    typealias DomainModel = Domain.PreJoin
    let name: String
    let id: String
    let uid: String
    let practiceName: String
    let createdAt: Timestamp
    let imageUrl: String
    let toUserId: String
    let circleImage: String
    var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as? String ?? String()
        self.id = dic["id"] as? String ?? String()
        self.circleImage = dic["circleImage"] as? String ?? String()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.imageUrl = dic["imageUrl"] as? String ?? String()
        self.uid = dic["uid"] as? String ?? String()
        self.practiceName = dic["practiceName"] as? String ?? String()
        self.toUserId = dic["toUserId"] as? String ?? String()
    }
    
    func convertToModel() -> Domain.PreJoin {
        return Domain.PreJoin(name: self.name,
                              id: self.id,
                              uid: self.uid,
                              practiceName: self.practiceName,
                              createdAt: self.createdAt,
                              imageUrl: self.imageUrl,
                              toUserId: self.toUserId,
                              circleImage: self.circleImage)
    }
}
