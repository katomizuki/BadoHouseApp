import Firebase

public struct Practice: Equatable {
    public let addressName: String
    public let circleId: String
    public let circleName: String
    public let circleUrlString: String
    public let court: Int
    public let gather: Int
    public let kind: String
    public let id: String
    public let maxLevel: String
    public let minLevel: String
    public let placeName: String
    public let price: String
    public let latitude: Double
    public let longitude: Double
    public let finish: Timestamp
    public let start: Timestamp
    public let deadLine: Timestamp
    public let title: String
    public let urlString: String
    public let userId: String
    public let userName: String
    public let userUrlString: String
    public let explain: String
    public var circleUrl: URL? {
        if let url = URL(string: circleUrlString) {
            return url
        } else {
            return nil
        }
    }
    public var userUrl: URL? {
        if let url = URL(string: userUrlString) {
            return url
        } else {
            return nil
        }
    }
    public var mainUrl: URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    public var startTimeSring: String {
        let date = start.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "yyyy年MM月dd日HH時mm分")
        return dateString
    }
    public var detailStartTimeString: String {
        let date = start.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    public var detailEndTimeString: String {
        let date = finish.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    public var detailDeadLineTimeString: String {
        let date = deadLine.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    public var isPreJoined: Bool {
        let array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "preJoin")
        return array.contains(id)
    }
    
    public init(addressName: String,
         circleId: String,
         circleName: String,
         circleUrlString: String,
         court: Int,
         gather: Int,
         kind: String,
         id: String,
         maxLevel: String,
         minLevel: String,
         placeName: String,
         price: String,
         latitude: Double,
         longitude: Double,
         finish: Timestamp,
         start: Timestamp,
         deadLine: Timestamp,
         title: String,
         urlString: String,
         userId: String,
         userName: String,
         userUrlString: String,
         explain: String) {
        self.addressName = addressName
        self.circleId = circleId
        self.circleName = circleName
        self.circleUrlString = circleUrlString
        self.court = court
        self.gather = gather
        self.kind = kind
        self.id = id
        self.maxLevel = maxLevel
        self.minLevel = minLevel
        self.placeName = placeName
        self.price = price
        self.latitude = latitude
        self.longitude = longitude
        self.finish = start
        self.start = start
        self.deadLine = deadLine
        self.title = title
        self.urlString = urlString
        self.userId = userId
        self.userName = userName
        self.userUrlString = userUrlString
        self.explain = explain
    }
}

