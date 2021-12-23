
import Firebase

struct TeamModel {
    var teamId: String
    var teamName: String
    var teamPlace: String
    var teamTime: String
    var teamLevel: String
    var teamImageUrl: String
    var teamUrl: String
    var createdAt: Timestamp
    var updatedAt: Timestamp
    init?(dic: [String: Any]) {
        guard let teamId = dic["teamId"] as? String,
              let teamName = dic["teamName"] as? String,
              let teamPlace = dic["teamPlace"] as? String,
              let teamTime = dic["teamTime"] as? String,
              let teamLevel = dic["teamLevel"] as? String,
              let teamImageUrl = dic["teamImageUrl"] as? String,
              let createdAt: Timestamp = dic["createdAt"] as? Timestamp,
              let updatedAt: Timestamp = dic["createdAt"] as? Timestamp else { return nil }
        self.teamId = teamId
        self.teamName = teamName
        self.teamPlace = teamPlace
        self.teamTime = teamTime
        self.teamLevel = teamLevel
        self.teamUrl = dic["teamUrl"] as? String ?? ""
        self.teamImageUrl = teamImageUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
