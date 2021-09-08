

import Foundation
import Firebase
import UIKit
extension Auth{
    
    //Mark Register
    static func register(name:String?,email:String?,password:String?,completion:@escaping (Bool,Error?) -> Void) {
        guard let email = email else { return }
        guard let name = name else { return }
        guard let password = password else { return }
        
        Auth.auth().createUser(withEmail: email,password: password) { result, error in
            if let error = error {
                print("createUser Error",error)
                completion(false,error)
                return
            }
            print("Register Success ")
            guard let uid = result?.user.uid else { return }
            Firestore.setUserData(uid: uid, password: password, email: email, name: name) { result in
                completion(result, error)
            }
        }
    }
    
    //Mark: Login
    static func loginFirebaseAuth(email:String,password:String,completion:@escaping (Bool,Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error",error)
                completion(false,error)
                return
            }
            print("Login Success")
            completion(true,error)
        }
    }
    
    
    
    //Mark:GetUserId
    static func getUserId()->String {
        guard let uid = Auth.auth().currentUser?.uid else { return ""}
        return uid
    }
}
//Mark:FireStore
extension Firestore{
    
    //Mark: setUserData
    static func setUserData(uid:String,password:String,email:String,name:String,completion:@escaping (Bool) ->()) {
        let dic = ["uid":uid,
                   "name":name,
                   "email":email,
                   "createdAt":Timestamp(),
                   "updatedAt":Timestamp()] as [String : Any]
        Ref.UsersRef.document(uid).setData(dic) { error in
            if let error = error {
                print("SetUserData",error)
            }
            completion(true)
            print("setUserData")
        }
    }
    
    //Mark UserDataUpdate
    static func updateUserInfo(dic:[String:Any],completion:@escaping ()->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).updateData(dic) { error in
            if let error = error {
                print("更新エラー",error)
                return
            }
            print("更新成功")
            completion()
        }
    }
    
    //Mark: UserDataGet
    static func getUserData(uid:String,compeltion:@escaping (User?)->Void) {
        Ref.UsersRef.document(uid).addSnapshotListener { snapShot, error in
            if let error = error {
                print("UserInfo Get Error",error)
                return
            }
            guard let dic = snapShot?.data() else { return }
            let user = User(dic: dic)
            compeltion(user)
        }
    }
    
    //Mark: DeleteData
    static func deleteData(collectionName:String,documentId:String) {
        Firestore.firestore().collection(collectionName).document(documentId).delete()
    }
    
    //Mark:createTeam
    static func createTeam(teamName:String,teamPlace:String,teamTime:String,teamLevel:String,teamImageUrl:String,friends:[User],teamUrl:String,tagArray:[String]) {
        let teamId = Ref.TeamRef.document().documentID
        //dictionary
        let dic = ["teamId":teamId,
                   "teamName":teamName,
                   "teamPlace":teamPlace,
                   "teamTime":teamTime,
                   "teamImageUrl":teamImageUrl,
                   "teamLevel":teamLevel,
                   "teamURL":teamUrl,
                   "createdAt":Timestamp(),
                   "updatedAt":Timestamp()] as [String : Any]
        Ref.TeamRef.document(teamId).setData(dic) { error in
            if let error = error {
                print("TeamData Error",error)
                return
            }
            print("TeamData Register Success")
        }
        //Mark:inviteTeamPlayer
        Firestore.sendTeamPlayerData(teamDic: dic, teamplayer: friends)
        Firestore.sendTeamTagData(teamId: teamId, tagArray: tagArray)
      
    }
    
    static func sendTeamTagData(teamId:String,tagArray:[String]) {
        let tagId =  Ref.TeamRef.document(teamId).collection("TeamTag").document().documentID
        for i in 0..<tagArray.count {
            Ref.TeamRef.document(teamId).collection("TeamTag").document("\(tagId + String(i))").setData(["tagId" : tagId,"tag":tagArray[i]])
        }
    }
    
    //Mark GetTeamTagData
    static func getTeamTagData(teamId:String,completion:@escaping ([TeamTag])->Void) {
        Ref.TeamRef.document(teamId).collection("TeamTag").getDocuments { snapShot, error in
            var teamTag = [TeamTag]()
            if let error = error {
                print("TeamTag Error",error)
            }
            guard let data = snapShot?.documents else { return }
            for doc in data {
                let safeData = doc.data()
                let tagId = safeData["tagId"] as? String ?? ""
                let tagString = safeData["tag"] as? String ?? ""
                let tag = TeamTag(tag: tagString, tagId: tagId)
                teamTag.append(tag)
            }
            completion(teamTag)
        }
    }
    
        
    
    //Mark: sendTeamPlayerData
    static func sendTeamPlayerData(teamDic:[String:Any],teamplayer:[User]) {
        print(#function)
        for i in 0..<teamplayer.count {
            let teamPlayerId = teamplayer[i].uid
            let dic = ["uid":teamPlayerId] as [String : Any]
            let teamId = teamDic["teamId"] as! String
            // TeamPlayer++
            Ref.TeamRef.document(teamId).collection("TeamPlayer").document(teamPlayerId).setData(dic) {
                error in
                if let error = error {
                    print(error)
                }
            }
            Firestore.plusOwnTeam(id: teamPlayerId, dic: teamDic)
        }
    }
    
    //Mark OwnTeamPlus
    static func plusOwnTeam(id:String,dic:[String:Any]) {
        let teamId = dic["teamId"] as! String
        Ref.UsersRef.document(id).collection("OwnTeam").document(teamId).setData(dic)
    }
    
    //Mark: getFriendData
    static func getFriendData(uid:String,completion:@escaping([String]) -> (Void)) {
        var friendId = [String]()
        Ref.UsersRef.document(uid).collection("Friends").addSnapshotListener { snapShot, error in
            if let error = error {
                print("FriendData error",error)
            }
            guard let dataArray = snapShot?.documents else { return }
            friendId = []
            for data in dataArray {
                let safeData = data.data()
                let id = safeData["uid"] as! String
                friendId.append(id)
            }
            completion(friendId)
        }
        
    }
    
    //Mark getOwnTeam
    static func getOwnTeam(uid:String,completion:@escaping ([TeamModel])->Void) {
        Ref.UsersRef.document(uid).collection("OwnTeam").addSnapshotListener { snapShot, error in
            if let error = error {
                print("OwnTeam",error)
            }
            var teamArray = [TeamModel]()
            guard let data = snapShot?.documents else { return }
            for doc in data {
                let safeData = doc.data()
                let teamId = safeData["teamId"] as? String ?? ""
                let teamName = safeData["teamName"] as? String ?? ""
                let teamTime = safeData["teamTime"] as? String ?? ""
                let teamPlace = safeData["teamPlace"] as? String ?? ""
                let teamImageUrl = safeData["teamImageUrl"] as? String ?? ""
                let teamUrl = safeData["teamURL"] as? String ?? ""
                let createdAt = safeData["createdAt"] as! Timestamp
                let updatedAt = safeData["updatedAt"] as! Timestamp
                let team = TeamModel(teamId: teamId, teamName: teamName, teamPlace: teamPlace, teamTime: teamTime, teamLevel: teamTime, teamImageUrl: teamImageUrl, teamUrl: teamUrl, createdAt: createdAt, updatedAt: updatedAt)
                teamArray.append(team)
            }
            completion(teamArray)
        }
    }
    
    static func getTeamPlayer(teamId:String,completion:@escaping ([String])->Void) {
        Ref.TeamRef.document(teamId).collection("TeamPlayer").addSnapshotListener { snapShot, error in
            var teamPlayers = [String]()
            guard let documents = snapShot?.documents else { return }
            teamPlayers = []
            for data in documents {
                let safeData = data.data()
                let teamPlayerId = safeData["uid"] as? String ?? ""
                teamPlayers.append(teamPlayerId)
            }
            completion(teamPlayers)
        }
    }
    
    
    static func friendAction(myId:String,friend:User,bool:Bool) {
        let id = friend.uid
        
        if bool {
            //true → plusFriend
            Ref.UsersRef.document(myId).collection("Friends").document(id).setData(["uid" : id])
        } else {
            // false　→ deleteFriend
            Ref.UsersRef.document(myId).collection("Friends").document(id).delete()
        }
    }
    
    static func searchFriend(friend:User,myId:String,completion:@escaping (Bool)->Void) {
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
    
    //Mark: sendEventData
    static func sendEventData(teamId:String,event:[String:Any],eventId:String) {
        //Mark:team→eventdata
        Ref.TeamRef.document(teamId).collection("Event").document(eventId).setData(event)
        Ref.EventRef.document(eventId).setData(event)
    }
    
    //Mark: TagData
    static func sendTagData(eventId:String,tags:[String],teamId:String) {
        for i in 0..<tags.count {
            let tag = tags[i]
            print(tag)
            let tagId = "\(Ref.EventRef.document(eventId).documentID + String(i))"
            let dic = ["tag":tag,"teamId":teamId,"tagId":tagId]
            Ref.EventRef.document(eventId).collection("Tag").document(tagId).setData(dic)
        }
    }
}

//Mark Storage
extension Storage {
    //Mark DownURL
    static func downloadStorage(userIconRef:StorageReference, completion:@escaping (URL)->Void){
        
        userIconRef.downloadURL { url, error in
            if let error = error {
                print(error)
                return
            }
            guard let url = url else { return }
            completion(url)
        }
    }
    
    //Mark: ProfileImageStorage
    static func addProfileImageToStorage(image:UIImage,dic:[String:Any],completion:@escaping() -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageUserImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { metaData, error in
            if let error = error {
                print("Image Save Error",error)
                return
            }
            print("Image Save Success")
            
            Storage.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                var dicWithImage = dic
                dicWithImage["profileImageUrl"] = urlString
                Firestore.updateUserInfo(dic: dicWithImage) {
                    completion()
                }
            }
        }
    }
    
    //Mark:TeamImageAdd
    static func addTeamImage(image:UIImage,completion: @escaping (String)->Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageTeamImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { metaData, error in
            if let error = error {
                print("Image Save Error",error)
                return
            }
            print("Image Save Succees")
            Storage.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
}

protocol GetGenderCount {
    func getGenderCount(count:[Int])
}

protocol GetBarChartDelegate {
    func getBarData(count:[Int])
}

class FetchFirestoreData {
    
    var delegate:GetGenderCount?
    var barDelegate:GetBarChartDelegate?
    
    func getGenderCount(teamPlayers:[User]) {
        var manCount = 0
        var womanCount = 0
        var otherCount = 0
        for i in 0..<teamPlayers.count {
            let playerId = teamPlayers[i].uid
            Firestore.getUserData(uid: playerId) { user in
                guard let gender = user?.gender else { return }
                if gender == "男性" {
                    manCount += 1
                    print("👿")
                } else if gender == "女性" {
                    womanCount += 1
                } else {
                    otherCount += 1
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.getGenderCount(count: [manCount,womanCount,otherCount])
        }
    }
    
    func teamPlayerLevelCount(teamPlayers:[User]) {
        var level1 = 0
        var level2 = 0
        var level3 = 0
        var level4 = 0
        var level5 = 0
        var level6 = 0
        var level7 = 0
        var level8 = 0
        var level9 = 0
        var level10 = 0
        for i in 0..<teamPlayers.count {
            let level = teamPlayers[i].level
            switch level {
            case "レベル1":
                level1 += 1
            case "レベル2":
                level2 += 1
            case "レベル3":
                level3 += 1
            case "レベル4":
                level4 += 1
            case "レベル5":
                level5 += 1
            case "レベル6":
                level6 += 1
            case "レベル7":
                level7 += 1
            case "レベル8":
                level8 += 1
            case "レベル9":
                level9 += 1
            case "レベル10":
                level10 += 1
            default:
                break
            }
        }
        self.barDelegate?.getBarData(count: [level1,level2,level3,level4,level5,level6,level7,level8,level9,level10])
    }
    
}
