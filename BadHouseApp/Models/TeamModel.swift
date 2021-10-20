import Foundation
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
    init(dic: [String: Any]) {
        self.teamId = dic["teamId"] as? String ?? ""
        self.teamName = dic["teamName"] as? String ?? ""
        self.teamPlace = dic["teamPlace"] as? String ?? ""
        self.teamTime = dic["teamTime"] as? String ?? ""
        self.teamLevel = dic["teamLevel"] as? String ?? "1"
        self.teamUrl = dic["teamUrl"] as? String ?? ""
        self.teamImageUrl = dic["teamImageUrl"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.updatedAt = dic["updatedAt"] as? Timestamp ?? Timestamp()
    }
}
