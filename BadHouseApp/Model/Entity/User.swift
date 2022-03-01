import Firebase
import FirebaseAuth

struct User: FirebaseModel, Equatable {
    
    var uid: String
    var name: String
    var email: String
    var createdAt: Timestamp
    var updatedAt: Timestamp
    var introduction: String
    var profileImageUrlString: String
    var level: String
    var gender: String
    var place: String
    var badmintonTime: String
    var age: String
    var racket: String
    var player: String
    var profileImageUrl: URL? {
        if let url = URL(string: profileImageUrlString) {
            return url
        } else {
            return nil
        }
    }
    var isMyself: Bool {
        return AuthRepositryImpl.getUid() == uid
    }
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.level = dic["level"] as? String ?? "レベル1"
        self.updatedAt = dic["updatedAt"] as? Timestamp ?? Timestamp()
        self.introduction = dic["introduction"] as? String ?? "未設定"
        self.profileImageUrlString = dic["profileImageUrl"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? "未設定"
        self.place = dic["place"] as? String ?? "未設定"
        self.badmintonTime = dic["badmintonTime"] as? String ?? "未設定"
        self.age = dic["age"] as? String ?? "未設定"
        self.racket = dic["racket"] as? String ?? "未設定"
        self.player = dic["player"] as? String ?? "未設定"
    }
}
