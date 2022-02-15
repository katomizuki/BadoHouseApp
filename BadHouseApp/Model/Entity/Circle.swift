import Firebase

struct Circle: Equatable, FirebaseModel {
    
    var id: String
    var features: [String]
    var time: String
    var price: String
    var place: String
    var name: String
    var member: [String]
    var additionlText: String
    var backGround: String
    var icon: String
    var members = [User]()
    var iconUrl: URL? {
        if let url = URL(string: icon) {
            return url
        } else {
            return nil
        }
    }
    var backGroundUrl: URL? {
        if let url = URL(string: backGround) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.features = dic["features"] as? [String] ?? []
        self.time = dic["time"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.place = dic["place"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.member = dic["member"] as? [String] ?? []
        self.additionlText = dic["additionlText"] as? String ?? ""
        self.backGround = dic["backGround"] as? String ?? ""
        self.icon = dic["icon"] as? String ?? ""
    }
}
