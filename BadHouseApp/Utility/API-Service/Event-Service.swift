import Foundation
struct EventServie {
    // Mark sendEventData
    static func sendEventData(teamId: String,event: [String: Any], eventId: String) {
        // Mark team→eventdata
        Ref.TeamRef.document(teamId).collection("Event").document(eventId).setData(event)
        Ref.EventRef.document(eventId).setData(event)
    }
    static func getmyEventId(completion: @escaping([Event]) -> Void) {
        var eventArray = [Event]()
        Ref.EventRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            let myEvent = data.filter { document in
                let safeData = document.data()
                let leaderId = safeData["userId"] as? String ?? ""
                return leaderId == AuthService.getUserId()
            }
            myEvent.forEach { data in
                let safeData = data.data() as [String: Any]
                let event = Event(dic: safeData)
                eventArray.append(event)
            }
            completion(eventArray)
        }
    }
    static func deleteEvent() {
        guard let now = DateUtils.getNow() else { return }
        Ref.EventRef.addSnapshotListener { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { element in
                let safeData = element.data()
                let endTime = safeData["eventLastTime"] as? String ?? "2015/03/04 12:34:56 +09:00"
                let eventId = safeData["eventId"] as? String ?? ""
                let date = DateUtils.dateFromString(string: endTime, format: "yyyy/MM/dd HH:mm:ss Z") ?? now
                if date < now {
                    DeleteService.deleteCollectionData(collectionName: "Event", documentId: eventId)
                }
            }
        }
    }
    static func getmyEventIdArray(uid: String, completion: @escaping([String]) -> Void) {
        var stringArray = [String]()
        Ref.UsersRef.document(uid).collection("Join").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safedata = doc.data()
                let id = safedata["id"] as? String ?? ""
                stringArray.append(id)
            }
            completion(stringArray)
        }
    }
}
// Mark EventTag-Extension
extension EventServie {
    static func getEventTagData(eventId: String, completion: @escaping([Tag]) -> Void) {
        var tagArray = [Tag]()
        Ref.EventRef.document(eventId).collection("Tag").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let documents = snapShot?.documents else { return }
            documents.forEach { document in
                let data = document.data()
                let tag = Tag(dic: data)
                tagArray.append(tag)
            }
            completion(tagArray)
        }
    }
    static func sendEventTagData(eventId: String, tags: [String], teamId: String) {
        for i in 0..<tags.count {
            let tag = tags[i]
            print(tag)
            let tagId = "\(Ref.EventRef.document(eventId).documentID + String(i))"
            let dic = ["tag": tag, "teamId": teamId, "tagId": tagId]
            Ref.EventRef.document(eventId).collection("Tag").document(tagId).setData(dic)
        }
    }
}
