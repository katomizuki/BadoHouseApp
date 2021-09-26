import Foundation
import Firebase
import UIKit
import CoreLocation

extension Auth {
    
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
                let boolArray = [Bool]()
                UserDefaults.standard.set(boolArray, forKey: uid)
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
    static func updateUserInfo(dic:[String:Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).updateData(dic) { error in
            if let error = error {
                print("更新エラー",error)
                return
            }
            print("更新成功")
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
    
    static func changeTrue(uid:String) {
        Ref.UsersRef.document(uid).collection("PreJoin").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { data in
                let safeData = data.data()
                let id = safeData["id"] as? String ?? ""
                Ref.UsersRef.document(uid).collection("PreJoin").document(id).setData(["id":id,"alertOrNot":true])
            }
        }
    }
    
    static func sendGroupChat(teamId:String,me:User,text:String) {
        let senderId = me.uid
        let senderUrl = me.profileImageUrl
        let senderName = me.name
        let id = Ref.TeamRef.document(teamId).collection("GroupChat").document().documentID
        let dic = ["senderId":senderId,"senderUrl":senderUrl,"senderName":senderName,"chatId":id,"timeStamp":Timestamp(),"text":text] as [String : Any]
        Ref.TeamRef.document(teamId).collection("GroupChat").document(id).setData(dic)
    }
    
   
    
    
    //Mark:getTeamData
    static func getTeamData(teamId:String,completion:@escaping (TeamModel)->Void) {
        
        Ref.TeamRef.document(teamId).addSnapshotListener { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.data() else { return }
            let dic = data as [String:Any]
            let team = TeamModel(dic: dic)
            completion(team)
        }
    }
    
    //Mark: DeleteData
    static func deleteData(collectionName:String,documentId:String) {
        Firestore.firestore().collection(collectionName).document(documentId).delete()
    }
    
    //Mark:DeleteChatData
    static func deleteSubCollectionData(collecionName:String,documentId:String,subCollectionName:String,subId:String) {
        Firestore.firestore().collection(collecionName).document(documentId).collection(subCollectionName).document(subId).delete()
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
    static func getTeamTagData(teamId:String,completion:@escaping ([Tag])->Void) {
        Ref.TeamRef.document(teamId).collection("TeamTag").getDocuments { snapShot, error in
            var teamTag = [Tag]()
            if let error = error {
                print("TeamTag Error",error)
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safeData = doc.data()
                let tag = Tag(dic: safeData)
                teamTag.append(tag)
            }
            completion(teamTag)
        }
    }
    
    static func sendChatroom(myId:String,youId:String,completion:@escaping(String)->Void) {
                let chatRoomId = Ref.ChatroomRef.document().documentID
                let chatRoomDic = ["chatRoomId":chatRoomId,"user":myId,"user2":youId]
                Ref.ChatroomRef.document(chatRoomId).setData(chatRoomDic)
                Ref.UsersRef.document(myId).collection("ChatRoom").document(chatRoomId).setData(["chatId":chatRoomId])
                Ref.UsersRef.document(youId).collection("ChatRoom").document(chatRoomId).setData(["chatId":chatRoomId])
                completion(chatRoomId)
    }
    
    static func sendChat(chatroomId:String,senderId:String,text:String,reciverId:String) {
        let dic = ["chatRoomId":chatroomId,"sender":senderId,"text":text,"reciver":reciverId,"sendTime":Timestamp()] as [String : Any]
        let chatId = Ref.ChatroomRef.document(chatroomId).collection("Content").document().documentID
        Ref.ChatroomRef.document(chatroomId).collection("Content").document(chatId).setData(dic)
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
            dataArray.forEach { data in
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
            teamArray = []
            data.forEach { doc in
                let safeData = doc.data()
                let dic = safeData as [String:Any]
                let team = TeamModel(dic: dic)
                teamArray.append(team)
            }
            completion(teamArray)
        }
    }
    
    static func getEventTagData(eventId:String,completion:@escaping([Tag])->Void) {
        var tagArray = [Tag]()
        Ref.EventRef.document(eventId).collection("Tag").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let documents = snapShot?.documents else { return }
            documents.forEach { document in
                let data = document.data()
                let tag = Tag(dic:data)
                tagArray.append(tag)
            }
            completion(tagArray)
        }
    }
    
    static func getTeamPlayer(teamId:String,completion:@escaping ([String])->Void) {
        Ref.TeamRef.document(teamId).collection("TeamPlayer").addSnapshotListener { snapShot, error in
            var teamPlayers = [String]()
            guard let documents = snapShot?.documents else { return }
            teamPlayers = []
            documents.forEach { data in
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
            print("plus")
            Ref.UsersRef.document(myId).collection("Friends").document(id).setData(["uid" : id])
            Ref.UsersRef.document(id).collection("Friends").document(myId).setData(["uid":myId])
        } else {
            // false　→ deleteFriend
            print("delete")
            Ref.UsersRef.document(id).collection("Friends").document(myId).delete()
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
    
    //Mark: sendInvite
    static func sendInvite(team:TeamModel,inviter:
    [User]) {
        let teamId = team.teamId
        let dic = ["teamId":teamId,
                   "teamName":team.teamName,
                   "teamPlace":team.teamPlace,
                   "teamTime":team.teamTime,
                   "teamImageUrl":team.teamImageUrl,
                   "teamLevel":team.teamLevel,
                   "teamURL":team.teamUrl,
                   "createdAt":team.createdAt,
                   "updatedAt":team.updatedAt] as [String : Any]
        inviter.forEach { element in
            let id = element.uid
            Ref.TeamRef.document(teamId).collection("TeamPlayer").document(id).setData(["uid":id])
            Ref.UsersRef.document(id).collection("OwnTeam").document(teamId).setData(dic)
        }
    }
    
    //Mark: getChatData
    static func getChatData(uid:String,completion:@escaping ([String])->Void) {
        var chatArray = [String]()
        Ref.UsersRef.document(uid).collection("ChatRoom").addSnapshotListener { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { element in
                let data = element.data()
                let chatId = data["chatId"] as? String ?? ""
                chatArray.append(chatId)
            }
            completion(chatArray)
        }
    }
    
    static func sendePreJoin(myId:String, eventId:String,leaderId:String) {
        Ref.EventRef.document(eventId).collection("PreJoin").document(myId).setData(["id":myId])
        Ref.UsersRef.document(leaderId).collection("PreJoin").document(myId).setData(["id":myId,"alertOrNot":false])
    }
    
    static func searchPreJoin(myId:String,eventId:String,completion:@escaping(Bool)->Void) {
        var bool = false
        Ref.EventRef.document(eventId).collection("PreJoin").getDocuments { snapShot, error in
            if let error = error {
                print(error)
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
    
    static func getmyEventId(completion:@escaping([Event])->Void) {
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
                return leaderId == Auth.getUserId()
            }
            myEvent.forEach { data in
                let safeData = data.data() as [String:Any]
                let event = Event(dic: safeData)
                eventArray.append(event)
            }
            completion(eventArray)
        }
    }
    
    static func sendJoin(eventId:String,uid:String) {
        Ref.EventRef.document(eventId).collection("Join").document(uid).setData(["id":uid])
    }
    static func sendPreJoin(eventId:String,userId:String) {
        Ref.EventRef.document(eventId).collection("PreJoin").document(userId).setData(["id":userId])
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
                    //今よりすぎていたら自動で消す,(イベントコレクション),
                    Firestore.deleteData(collectionName: "Event", documentId: eventId)

                }
            }
        }
    }
    
    
    
    
    //Mark:LastGetChatData
    static func getChatLastData(chatId:String,completion:@escaping(Chat)-> Void){
        var textArray = [Chat]()
        Ref.ChatroomRef.document(chatId).collection("Content").order(by: "sendTime").addSnapshotListener { snapShot, error in
            textArray = []
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            if document.isEmpty {
                let dic = ["sendTime": nil,"text":"","sender":"","reciver":""] as [String:Any]
                let chat = Chat(dic: dic)
                textArray.append(chat)
            } else {
            document.forEach { element in
                let data = element.data()
                let chat = Chat(dic:data)
                textArray.append(chat)
                }
            }
            guard let lastComment = textArray.last else { return }
            completion(lastComment)
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
                Firestore.updateUserInfo(dic: dicWithImage)
                   
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
    
    //Mark:StorageAddImage
    static func addEventImage(image:UIImage,completion:@escaping (String)->Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageEventImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { metaData, error in
            if let error = error {
                print("Image Save Error",error)
                return
            }
            Storage.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
}




