import Foundation
struct EventServie {
    static func sendEventData(teamId: String,
                              event: [String: Any],
                              eventId: String,
                              completion: @escaping(Result<String, Error>) -> Void) {
        Ref.TeamRef.document(teamId).collection("Event").document(eventId).setData(event) { error in
            if let error = error {
                print(error)
                completion(.failure(FirebaseError.netError))
                return
            }
            Ref.EventRef.document(eventId).setData(event) { error in
                if let error = error {
                    print(error)
                    completion(.failure(FirebaseError.netError))
                    return
                }
                completion(.success("Success"))
            }
        }
    }
    static func getmyEventId(completion: @escaping([Event])-> Void) {
        var eventArray = [Event]()
        Ref.EventRef.getDocuments { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
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
                if let event = event {
                    eventArray.append(event)
                }
            }
            completion(eventArray)
        }
    }
    static func deleteEvent() {
        guard let now = DateUtils.getNow() else { return }
        Ref.EventRef.addSnapshotListener { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
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
                print(error.localizedDescription)
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
