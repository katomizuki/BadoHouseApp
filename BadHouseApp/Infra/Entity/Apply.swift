import Foundation
import Domain

struct Apply: FirebaseModel {
    
    typealias DomainModel = ApplyModel
    
    let uid: String
    let createdAt: String
    let imageUrl: String
    let name: String
    let toUserId: String
    var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? String ?? ""
        self.imageUrl = dic["imageUrl"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.toUserId = dic["toUserId"] as? String ?? ""
    }
    
    func convertToModel() -> ApplyModel {
        return ApplyModel(uid: self.uid,
                          createdAt: self.createdAt,
                          imageUrl: self.imageUrl,
                          name: self.name,
                          toUserId: self.toUserId)
    }
}
