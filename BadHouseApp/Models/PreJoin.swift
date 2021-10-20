import Foundation

struct PreJoin {
    var id: String
    var alertOrNot: Bool
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.alertOrNot = dic["alertOrNot"] as? Bool ?? true
    }
}
