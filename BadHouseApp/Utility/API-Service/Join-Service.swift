import Firebase
import Foundation
import RxSwift

struct JoinService {
    static func changePrejoinTrue(uid: String) {
        Ref.UsersRef.document(uid).collection("PreJoin").getDocuments { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { data in
                let safeData = data.data()
                let id = safeData["id"] as? String ?? ""
                Ref.UsersRef.document(uid).collection("PreJoin").document(id).setData(["id": id,
                    "alertOrNot": true])
            }
        }
    }
    static func sendPreJoinDataToEventAndUser(myId: String, eventId: String, leaderId: String) {
        Ref.EventRef.document(eventId).collection("PreJoin").document(myId).setData(["id": myId])
        Ref.UsersRef.document(leaderId).collection("PreJoin").document(myId).setData(["id": myId,
            "alertOrNot": false])
        Ref.UsersRef.document(myId).collection("Join").document(eventId).setData(["id": eventId])
    }
    static func searchPreJoinData(myId: String, eventId: String, completion: @escaping(Bool) -> Void) {
        var bool = false
        Ref.EventRef.document(eventId).collection("PreJoin").getDocuments { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { data in
                let safeData = data.data()
                let id = safeData["id"] as? String ?? ""
                if myId == id {
                    bool = true
                }
            }
            completion(bool)
        }
    }
    static func sendJoinData(eventId: String,
                             uid: String,
                             completion: @escaping (Result<String, Error?>) -> Void) {
        Ref.EventRef.document(eventId).collection("Join").document(uid).setData(["id": uid]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(FirebaseError.netError))
                return
            }
            completion(.success("sucess"))
        }
    }
    static func sendPreJoinData(eventId: String,
                                userId: String,
                                completion: @escaping (Result<String, Error?>) -> Void) {
        Ref.EventRef.document(eventId).collection("PreJoin").document(userId).setData(["id": userId]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(FirebaseError.netError))
                return
            }
            completion(.success("success"))
        }
    }
    static func sendNotificationtoPrejoin(uid: String, completion: @escaping(Bool) -> Void) {
        Ref.UsersRef.document(uid).collection("PreJoin").addSnapshotListener { snapShot, error in
            var boolArray = [PreJoin]()
            var result = false
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { data in
                let safeData = data.data()
                let pre = PreJoin(dic: safeData)
                if let pre = pre {
                    boolArray.append(pre)
                }
            }
            if boolArray.filter({ $0.alertOrNot == false }).count >= 1 {
                result = true
            }
            completion(result)
        }
    }
}
