import Foundation
import Firebase

struct UserService {
    //Mark: setUserData
    static func setUserData(uid: String, password: String, email: String, name: String, completion: @escaping (Bool) -> Void) {
        let dic = ["uid": uid,
                   "name": name,
                   "email": email,
                   "createdAt": Timestamp(),
                   "updatedAt": Timestamp()] as [String: Any]
        Ref.UsersRef.document(uid).setData(dic) { error in
            if let error = error {
                print("SetUserData",error)
            }
            completion(true)
            print("setUserData")
        }
    }
    // Mark UserDataUpdate
    static func updateUserData(dic: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).updateData(dic) { error in
            if let error = error {
                print("更新エラー", error)
                return
            }
            print("更新成功")
        }
    }
    // Mark UserDataGet
    static func getUserData(uid: String, compeltion: @escaping (User?) -> Void) {
        Ref.UsersRef.document(uid).addSnapshotListener { snapShot, error in
            if let error = error {
                print("UserInfo Get Error", error)
                return
            }
            guard let dic = snapShot?.data() else { return }
            let user = User(dic: dic)
            compeltion(user)
        }
    }
}
// Mark OwnTeam-Extension
extension UserService {
    static func plusOwnTeam(id: String, dic: [String: Any]) {
        let teamId = dic["teamId"] as! String
        Ref.UsersRef.document(id).collection("OwnTeam").document(teamId).setData(dic)
    }
    static func getOwnTeam(uid: String, completion: @escaping ([String]) -> Void) {
        var teamIdArray = [String]()
        Ref.UsersRef.document(uid).collection("OwnTeam").addSnapshotListener { snapShot, error in
            if let error = error {
                print("OwnTeam", error)
            }
            guard let data = snapShot?.documents else { return }
            teamIdArray = []
            data.forEach { doc in
                let safeData = doc.data()
                let teamId = safeData["teamId"] as? String ?? ""
                teamIdArray.append(teamId)
            }
            completion(teamIdArray)
        }
    }
}
// Mark Friend-Extension
extension UserService {
    static func getFriendData(uid: String, completion: @escaping([String]) -> Void) {
        var friendId = [String]()
        Ref.UsersRef.document(uid).collection("Friends").addSnapshotListener { snapShot, error in
            if let error = error {
                print("FriendData error", error)
            }
            guard let dataArray = snapShot?.documents else { return }
            friendId = []
            dataArray.forEach { data in
                let safeData = data.data()
                let id = safeData["uid"] as! String
                friendId.append(id)
            }
            completion(friendId)
        }
    }
    static func friendAction(myId: String, friend: User, bool: Bool) {
        let id = friend.uid
        if bool {
            Ref.UsersRef.document(myId).collection("Friends").document(id).setData(["uid": id])
            Ref.UsersRef.document(id).collection("Friends").document(myId).setData(["uid": myId])
        } else {
            Ref.UsersRef.document(id).collection("Friends").document(myId).delete()
            Ref.UsersRef.document(myId).collection("Friends").document(id).delete()
        }
    }
    static func searchFriend(friend: User, myId: String, completion: @escaping (Bool) -> Void) {
        let targetId = friend.uid
        var bool = false
        Ref.UsersRef.document(myId).collection("Friends").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let documents = snapShot?.documents else { return }
            for doc in documents {
                let safeData = doc.data()
                let friendId = safeData["uid"] as! String
                if targetId == friendId {
                    bool = true
                }
            }
            completion(bool)
        }
    }
}
