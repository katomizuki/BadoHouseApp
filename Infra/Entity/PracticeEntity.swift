import Firebase
import Domain
struct Practice: FirebaseModel {
    typealias DomainModel = Domain.Practice
    
    let addressName: String
    let circleId: String
    let circleName: String
    let circleUrlString: String
    let court: Int
    let gather: Int
    let kind: String
    let id: String
    let maxLevel: String
    let minLevel: String
    let placeName: String
    let price: String
    let latitude: Double
    let longitude: Double
    let finish: Timestamp
    let start: Timestamp
    let deadLine: Timestamp
    let title: String
    let urlString: String
    let userId: String
    let userName: String
    let userUrlString: String
    let explain: String
    var circleUrl: URL? {
        if let url = URL(string: circleUrlString) {
            return url
        } else {
            return nil
        }
    }
    var userUrl: URL? {
        if let url = URL(string: userUrlString) {
            return url
        } else {
            return nil
        }
    }
    var mainUrl: URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    var startTimeSring: String {
        let date = start.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "yyyy年MM月dd日HH時mm分")
        return dateString
    }
    var detailStartTimeString: String {
        let date = start.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    var detailEndTimeString: String {
        let date = finish.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    var detailDeadLineTimeString: String {
        let date = deadLine.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    var isPreJoined: Bool {
        let array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "preJoin")
        return array.contains(id)
    }
    
    init(dic: [String: Any]) {
        self.addressName = dic["addressName"] as? String ?? ""
        self.circleId = dic["circleId"] as? String ?? ""
        self.circleName = dic["circleName"] as? String ?? ""
        self.circleUrlString = dic["circleUrlString"] as? String ?? ""
        self.court = dic["court"] as? Int ?? 0
        self.gather = dic["gather"] as? Int ?? 0
        self.kind = dic["kind"] as? String ?? ""
        self.id = dic["id"] as? String ?? ""
        self.maxLevel = dic["maxLevel"] as? String ?? ""
        self.minLevel = dic["minLevel"] as? String ?? ""
        self.placeName = dic["placeName"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.latitude = dic["latitude"] as? Double ?? 0.0
        self.longitude = dic["longitude"] as? Double ?? 0.0
        self.finish = dic["finish"] as? Timestamp ?? Timestamp()
        self.start = dic["start"] as? Timestamp ?? Timestamp()
        self.deadLine = dic["deadLine"] as? Timestamp ?? Timestamp()
        self.title = dic["title"] as? String ?? ""
        self.urlString = dic["urlString"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userUrlString = dic["userUrlString"] as? String ?? ""
        self.explain = dic["explain"] as? String ?? ""
    }
    
    func convertToModel() -> Domain.Practice {
        return Domain.Practice(addressName: self.addressName,
                               circleId: self.circleId,
                               circleName: self.circleName,
                               circleUrlString: self.circleUrlString,
                               court: self.court,
                               gather: self.gather,
                               kind: self.kind,
                               id: self.id,
                               maxLevel: self.maxLevel,
                               minLevel: self.minLevel,
                               placeName: self.placeName,
                               price: self.price,
                               latitude: self.latitude,
                               longitude: self.longitude,
                               finish: self.finish,
                               start: self.start,
                               deadLine: self.deadLine,
                               title: self.title,
                               urlString: self.urlString,
                               userId: self.userId,
                               userName: self.userName,
                               userUrlString: self.userUrlString,
                               explain: self.explain)
    }
}
