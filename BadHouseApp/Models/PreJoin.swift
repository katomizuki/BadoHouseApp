import Firebase
struct PreJoin {
    let name: String
    let id: String
    let uid: String
    let practiceName: String
    let createdAt: Timestamp
    let imageUrl: String
    let toUserId: String
    let circleImage: String
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
}
