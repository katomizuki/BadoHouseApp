
import Firebase

struct Practice {
    var eventId: String
    var eventTime: String
    var eventPlace: String
    var teamName: String
    var eventStartTime: String
    var eventFinishTime: String
    var eventCourtCount: String
    var eventGatherCount: String
    var detailText: String
    var money: String
    var kindCircle: String
    var eventTitle: String
    var eventUrl: String
    var teamId: String
    var latitude: Double
    var longitude: Double
    var distance: Double
    var teamImageUrl: String
    var placeAddress: String
    var eventLevel: String
    var userId: String
    init?(dic: [String: Any]) {
        guard let eventStartTime = dic["eventStartTime"] as? String,
              let eventId = dic["eventId"] as? String,
              let eventFinishTime = dic["eventLastTime"] as? String,
              let money = dic["eventMoney"] as? String,
              let gatherCount = dic["gatherCount"] as? String,
              let eventTitle =  dic["eventTitle"] as? String,
              let kindCircle = dic["kindCircle"] as? String,
              let eventPlace = dic["place"] as? String,
              let teamId = dic["teamId"] as? String,
              let eventUrl = dic["urlEventString"] as? String,
              let teamName = dic["teamName"] as? String,
              let eventTime = dic["time"] as? String,
              let eventCourtCount = dic["courtCount"] as? String,
              let latitude = dic["latitude"] as? Double,
              let longitude = dic["longitude"] as? Double,
              let teamImageUrl = dic["teamImageUrl"] as? String,
              let placeAddress = dic["placeAddress"] as? String,
              let eventLevel = dic["eventLavel"] as? String,
              let userId = dic["userId"] as? String else { return nil }
        self.eventStartTime = eventStartTime
        self.eventId = eventId
        self.eventFinishTime = eventFinishTime
        self.money = money
        self.eventGatherCount = gatherCount
        self.eventTitle = eventTitle
        self.kindCircle =  kindCircle
        self.eventPlace =  eventPlace
        self.teamId = teamId
        self.teamName =  teamName
        self.eventTime =  eventTime
        self.eventUrl =  eventUrl
        self.detailText = dic["detailText"] as? String ?? ""
        self.eventCourtCount = eventCourtCount
        self.latitude = latitude
        self.longitude =  longitude
        self.teamImageUrl = teamImageUrl
        self.placeAddress = placeAddress
        self.eventLevel = eventLevel
        self.userId = userId
        self.distance = dic["distance"] as? Double ?? 0.0
    }
}
