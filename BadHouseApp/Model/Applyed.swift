import Foundation

struct Applyed: FirebaseModel {
    let uid: String
    let createdAt: String
    let imageUrl: String
    let name: String
    let fromUserId: String
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
        self.fromUserId = dic["fromUserId"] as? String ?? ""
    }
}
