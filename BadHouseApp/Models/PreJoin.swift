

struct PreJoin {
    var id: String
    var alertOrNot: Bool
    init?(dic: [String: Any]) {
        guard let id = dic["id"] as? String else { return nil }
        guard let alertOrNot = dic["alertOrNot"] as? Bool else { return nil }
        self.id = id
        self.alertOrNot =  alertOrNot
    }
}
