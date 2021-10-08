import Foundation
import Firebase

struct Event {
    var eventId:String
    var eventTime:String
    var eventPlace:String
    var teamName:String
    var eventStartTime:String
    var eventFinishTime:String
    var eventCourtCount:String
    var eventGatherCount:String
    var detailText:String
    var money:String
    var kindCircle:String
    var eventTitle:String
    var eventUrl:String
    var teamId:String
    var latitude:Double
    var longitude:Double
    var distance:Double
    var teamImageUrl:String
    var placeAddress:String
    var eventLevel:String
    var userId:String
    
    init(dic:[String:Any]) {
        self.eventStartTime = dic["eventStartTime"] as? String ?? "2015/03/04 12:34:56 +09:00"
        self.eventId = dic["eventId"] as? String ?? ""
        self.eventFinishTime = dic["eventLastTime"] as? String ?? "2015/03/04 12:34:56 +09:00"
        self.money = dic["eventMoney"] as? String ?? "1000"
        self.eventGatherCount = dic["gatherCount"] as? String ?? "1"
        self.eventTitle = dic["eventTitle"] as? String ?? "バドハウス"
        self.kindCircle = dic["kindCircle"] as? String ?? "社会人サークル"
        self.eventPlace = dic["place"] as? String ?? "神奈川県"
        self.teamId = dic["teamId"] as? String ?? ""
        self.teamName = dic["teamName"] as? String ?? ""
        self.eventTime = dic["time"] as? String ?? ""
        self.eventUrl = dic["urlEventString"] as? String ?? ""
        self.detailText = dic["detailText"] as? String ?? ""
        self.eventCourtCount = dic["courtCount"] as? String ?? "1"
        self.latitude = dic["latitude"] as? Double ?? 35.680
        self.longitude = dic["longitude"] as? Double ?? 139.767
        self.teamImageUrl = dic["teamImageUrl"] as? String ?? ""
        self.placeAddress = dic["placeAddress"] as? String ?? ""
        self.eventLevel = dic["eventLavel"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.distance = dic["distance"] as? Double ?? 0.0
    }
    
}
