import Foundation
import Firebase
import CoreLocation
import RxSwift

protocol GetGenderCount {
    func getGenderCount(count:[Int])
}
protocol GetBarChartDelegate {
    func getBarData(count:[Int])
}
protocol GetEventDelegate {
    func getEventData(eventArray:[Event])
}
protocol GetEventSearchDelegate {
    func getEventSearchData(eventArray:[Event])
}
protocol GetEventTimeDelegate {
    func getEventTimeData(eventArray:[Event])
}
protocol GetDetailDataDelegate {
    func getDetailData(eventArray:[Event])
}
protocol GetChatDataDelgate {
    func getChatData(chatArray:[Chat])
}
protocol GetChatRoomDataDelegate {
    func getChatRoomData(chatRoomArray:[ChatRoom])
}
protocol GetUserDataDelegate {
    func getUserData(userArray:[User])
}

protocol GetGroupChatDelegate {
    func getGroupChat(chatArray:[GroupChatModel])
}
protocol GetPrejoinDataDelegate {
    func getPrejoin(preJoin:[[String]])
}
protocol GetJoinDataDelegate {
    func getJoin(joinArray:[[String]])
}
protocol GetFriendDelegate {
    func getFriend(friendArray:[User])
}
protocol GetChatListDelegate {
    func getChatList(userArray:[User],anotherArray:[User],lastChatArray:[Chat],chatModelArray:[ChatRoom])
}
protocol GetVideoDelegate {
    func getVideo(videoArray:[VideoModel])
}
protocol GetGroupDelegate {
    func getGroup(groupArray:[TeamModel])
}
protocol GetMyEventDelegate {
    func getEvent(eventArray:[Event])
}


class FetchFirestoreData {
    
    var delegate:GetGenderCount?
    var barDelegate:GetBarChartDelegate?
    var eventDelegate:GetEventDelegate?
    var eventSearchDelegate:GetEventSearchDelegate?
    var eventTimeDelegate:GetEventTimeDelegate?
    var detailDelegate:GetDetailDataDelegate?
    var chatDelegate:GetChatDataDelgate?
    var chatRoomDelegate:GetChatRoomDataDelegate?
    var userDelegate:GetUserDataDelegate?
    var groupChatDataDelegate:GetGroupChatDelegate?
    var preDelegate:GetPrejoinDataDelegate?
    var joinDelegate:GetJoinDataDelegate?
    var friendDelegate:GetFriendDelegate?
    var chatListDelegate:GetChatListDelegate?
    var videoDelegate:GetVideoDelegate?
    var groupSearchDelegate:GetGroupDelegate?
    var myEventDelegate:GetMyEventDelegate?
    
    func friendData(idArray:[String]) {
        var array = [User]()
        for i in 0..<idArray.count {
            let uid = idArray[i]
            Firestore.getUserData(uid: uid) { friend in
                guard let friend = friend else { return }
                array.append(friend)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.friendDelegate?.getFriend(friendArray: array)
        }
    }
    
    func getmyEventData(idArray:[String]) {
        var eventArray = [Event]()
        idArray.forEach { id in
            Ref.EventRef.document(id).getDocument { Snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = Snapshot?.data() else { return }
                let event = Event(dic: data)
                eventArray.append(event)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.myEventDelegate?.getEvent(eventArray: eventArray)
        }
    }
    
    
    func getMyEventData(uid:String) {
        var eventArray = [Event]()
        Ref.UsersRef.document(uid).collection("Join").getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let document = snapShot?.documents else { return }
            document.forEach { data in
                let safeData = data.data()
                let id = safeData["id"] as? String ?? ""
                Ref.EventRef.document(id).getDocument { snap, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let safeData = snap?.data() else { return }
                    let event = Event(dic: safeData)
                    eventArray.append(event)
                }
            }
        }
        self.myEventDelegate?.getEvent(eventArray: eventArray)
    }
    
    func getChatListData(chatModelArray:[ChatRoom]) {
        var userArray = [User]()
        var anotherArray = [User]()
        var lastCommentArray = [Chat]()
        for i in 0..<chatModelArray.count {
            let userId = chatModelArray[i].user
            let anotherId = chatModelArray[i].user2
            let chatId = chatModelArray[i].chatRoom
        
            Firestore.getUserData(uid: userId) { user in
                guard let user = user else { return }
                userArray.append(user)
            }
            Firestore.getUserData(uid: anotherId) { another in
                guard let another = another else { return }
                anotherArray.append(another)
            }
            Firestore.getChatLastData(chatId: chatId) { lastComment in
                lastCommentArray.append(lastComment)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.chatListDelegate?.getChatList(userArray: userArray, anotherArray: anotherArray, lastChatArray: lastCommentArray,chatModelArray:chatModelArray)
        }
        
    }
    
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
    
    func searchFriends(text:String) {
        var userArray = [User]()
        Ref.UsersRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { data in
                let safeData = data.data()
                let name = safeData["name"] as? String ?? ""
                let id = safeData["uid"] as? String ?? ""
                if name.contains(text) && id != Auth.getUserId() {
                     let user = User(dic: safeData)
                    userArray.append(user)
                }
            }
            self.userDelegate?.getUserData(userArray: userArray)
        }
    }
    
    func teamPlayerLevelCount(teamPlayers:[User]) {
        print(teamPlayers)
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
    
    func fetchEventData(latitude:Double,longitude:Double) {
        Ref.EventRef.addSnapshotListener { snapShot, error in
            var eventArray = [Event]()
            if let error = error {
                print("EventData",error)
            }
            guard let data = snapShot?.documents else { return }
            eventArray = []
            data.forEach { doc in
                let safeData = doc.data() as [String:Any]
                let event = Event(dic:safeData)
                eventArray.append(event)
            }
            //Sort＆Search
            self.sortDate(data: eventArray,latitude:latitude,longitude:longitude)
        }
    }
    
    func sortDate(data:[Event],latitude:Double,longitude:Double) {
        var data = data
        data = data.sorted(by: {
            $0.eventStartTime.compare($1.eventStartTime) == .orderedAscending
        })
        
        guard let now = DateUtils.getNow() else { return }
        //開始日と募集日をsortして条件分岐する。
        data = data.filter { event in
            let dateString = event.eventStartTime
            let dateData = DateUtils.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z") ?? now
            let time = event.eventTime
            let eventTime = DateUtils.dateFromString(string: time, format: "yyyy/MM/dd HH:mm:ss Z") ?? now
            return dateData >= now && eventTime >= now
        }
        //dataを近い順に回す。
        
        for i in 0..<data.count {
            let eventLatitude = data[i].latitude
            let eventLongitude = data[i].longitude
            let currentPosition:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let eventPosition:CLLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
            let distance = currentPosition.distance(from: eventPosition)
            data[i].distance = distance
        }
        
        data = data.sorted(by: {
            $0.distance < $1.distance
        })
        self.eventDelegate?.getEventData(eventArray: data)
    }
    
    func searchText(text:String) {
        var eventArray = [Event]()
        Ref.EventRef.getDocuments { Snapshot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = Snapshot?.documents else {return}
            data.forEach { doc in
                let safeData = doc.data()
                let placeAddress = safeData["placeAddress"] as? String ?? ""
                let place = safeData["place"] as? String ?? ""
                let teamName = safeData["teamName"] as? String ?? ""
                let kindCircle = safeData["kindCircle"] as? String ?? ""
                let eventTitle = safeData["eventTitle"] as? String ?? "バドハウス"
                if placeAddress.contains(text) || place.contains(text) || teamName.contains(text) || kindCircle.contains(text) || eventTitle.contains(text) {
                    let event = Event(dic:safeData)
                    eventArray.append(event)
                }
            }
            self.eventSearchDelegate?.getEventSearchData(eventArray: eventArray)
        }
    }
    
    func searchDateEvent(dateString:String,text:String) {
        var eventArray = [Event]()
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 0)
        let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
        let keyDate = String(dateString[startIndex..<endIndex])
        Ref.EventRef.getDocuments { snapShot, error in
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safeData = doc.data()
                let eventStartTime = safeData["eventStartTime"] as? String ?? ""
                let firstIndex = eventStartTime.index(eventStartTime.startIndex, offsetBy: 0)
                let lastIndex = eventStartTime.index(eventStartTime.startIndex, offsetBy: 10)
                let startTimeString = String(eventStartTime[firstIndex..<lastIndex])
                if startTimeString == keyDate {
                    let event = Event(dic:safeData)
                    eventArray.append(event)
                }
            }
            eventArray = eventArray.filter { $0.placeAddress.contains(text) || $0.eventPlace.contains(text) }
            self.eventTimeDelegate?.getEventTimeData(eventArray: eventArray)
        }
    }
    
    func detailSearchEventData(title:String,circle:String,level:String,placeAddressString:String,money:String,time:String) {
        var eventArray = [Event]()
        Ref.EventRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safeData = doc.data()
                let event = Event(dic: safeData)
                eventArray.append(event)
            }
     
            if title != "" {
                eventArray = eventArray.filter { $0.eventTitle.contains(title) }
            }
            
            if circle != "" {
                eventArray = eventArray.filter{ $0.kindCircle == circle }
            }
            if placeAddressString != "" {
                eventArray = eventArray.filter{ $0.placeAddress.contains(placeAddressString) }
            }
            if money != "" {
                eventArray = self.searchMoney(money: money, events: eventArray)
            }
            if level != "" {
                eventArray = self.searchLevel(searchLevel: level, event: eventArray)
          }
            if time != "" {
                eventArray = self.searchTime(time: time, event: eventArray)
            }
            self.detailDelegate?.getDetailData(eventArray: eventArray)
        }
    }
    
    func searchMoney(money:String,events:[Event])->[Event] {
        var eventArray = [Event]()
        for i in 0..<events.count {
            let eventMoney = Int(events[i].money) ?? 500
            if money == "500円~1000円" {
                if 500 <= eventMoney && eventMoney <= 1000 {
                    eventArray.append(events[i])
                }
            } else if money == "1000円~2000円" {
                if 1000 <= eventMoney && 2000 >= eventMoney {
                    eventArray.append(events[i])
                }
            } else {
                if 2000 <= eventMoney {
                    eventArray.append(events[i])
                }
            }
        }
        return eventArray
    }
    
    
    func searchLevel(searchLevel:String,event:[Event])->[Event] {
        var eventArray = [Event]()

        for i in 0..<event.count {
            let level = event[i].eventLevel
            let startIndex = level.index(level.startIndex, offsetBy: 3)
            let startLevel = String(level[startIndex])
            let endLevel = String(level.suffix(1)) == "0" ? "10":String(level.suffix(1))
            let min = Int(startLevel) ?? 0
            let max = Int(endLevel) ?? 10
            let first = searchLevel.index(searchLevel.startIndex, offsetBy: 3)
            let string = String(searchLevel[first])
            let targetLevel = Int(string) ?? 5
            if min <= targetLevel && max >= targetLevel {
                eventArray.append(event[i])
            }
        }
        return eventArray
    }
    
    func searchTime(time:String ,event:[Event])->[Event] {
        print(#function)
        var eventArray = [Event]()
        eventArray = event.filter { $0.eventStartTime == time }
        return eventArray
    }
    
    func getChatData(meId:String,youId:String,completion:@escaping(String)->Void){
        print(#function)
        var string = ""
        Ref.ChatroomRef.addSnapshotListener { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { doc in
                let data = doc.data()
                let userId = data["user"] as? String ?? ""
                let userId2 = data["user2"] as? String ?? ""
                let chatRoomId = data["chatRoomId"] as? String ?? ""
                if (userId == meId && youId == userId2) || (userId == youId && meId == userId2) {
                 string = chatRoomId
                }
            }
            completion(string)
        }
    }
    
    func getChat(chatId:String) {
        Ref.ChatroomRef.document(chatId).collection("Content").order(by: "sendTime").addSnapshotListener { snapShot, error in
            var chatArray = [Chat]()
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { doc in
                let data = doc.data()
                let chat = Chat(dic:data)
                chatArray.append(chat)
            }
            self.chatDelegate?.getChatData(chatArray: chatArray)
        }
    }
    func getChatRoomModel(chatId:[String]){
            var chatRoomModelArray = [ChatRoom]()
        for i in 0..<chatId.count {
            Ref.ChatroomRef.document(chatId[i]).getDocument { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = snapShot?.data() else { return }
                let chatRoomModel = ChatRoom(dic: data)
                chatRoomModelArray.append(chatRoomModel)
                print(chatRoomModel)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print(chatRoomModelArray)
            self.chatRoomDelegate?.getChatRoomData(chatRoomArray: chatRoomModelArray)
        }
    }
    
    func getGroupChat(teamId:String) {
        var groupChat = [GroupChatModel]()
        Ref.TeamRef.document(teamId).collection("GroupChat").order(by: "timeStamp").addSnapshotListener { snapShot, error in
            if let error = error  {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            groupChat = []
            document.forEach { data in
                let safeData = data.data()
                let groupChatModel = GroupChatModel(dic: safeData)
                groupChat.append(groupChatModel)
            }
            self.groupChatDataDelegate?.getGroupChat(chatArray: groupChat)
        }
    }
    
     func getEventPreJoinData(eventArray:[Event]) {
        var stringArray = [[String]]()
        for i in 0..<eventArray.count {
            let eventId = eventArray[i].eventId
            Ref.EventRef.document(eventId).collection("PreJoin").addSnapshotListener { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let document = snapShot?.documents else { return }
                var tempArray = [String]()
                document.forEach { data in
                    let safeData = data.data()
                    let id = safeData["id"] as? String ?? ""
                    print(id)
                    tempArray.append(id)
                }
                stringArray.append(tempArray)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.preDelegate?.getPrejoin(preJoin: stringArray)
        }
    }
    
    func fetchJoinData(eventArray:[Event]) {
        var stringArray = [[String]]()
        for i in 0..<eventArray.count {
            let eventId = eventArray[i].eventId
            Ref.EventRef.document(eventId).collection("Join").addSnapshotListener { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let document = snapShot?.documents else { return }
                var tempArray = [String]()
                document.forEach { data in
                    let safeData = data.data()
                    let id = safeData["id"] as? String ?? ""
                    tempArray.append(id)
                }
                stringArray.append(tempArray)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.joinDelegate?.getJoin(joinArray: stringArray)
        }
    }
    
    func getVideoData() {
        var videoArray = [VideoModel]()
        Ref.VideoRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { doc in
                let data = doc.data()
                let video = VideoModel(dic: data)
                videoArray.append(video)
            }
            videoArray.shuffle()
            let array = Array(videoArray[0..<3])
            self.videoDelegate?.getVideo(videoArray:array)
        }
    }
    
    func searchVideoData(text:String) {
        var videoArray = [VideoModel]()
        Ref.VideoRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { doc in
                let data = doc.data()
                let video = VideoModel(dic: data)
                videoArray.append(video)
            }
            var array = videoArray.filter { $0.keyWord == text }
            array.shuffle()
            if array.count >= 3 {
                array = Array(array[0..<3])
                self.videoDelegate?.getVideo(videoArray:array)
            } else {
                videoArray = Array(videoArray[0..<3])
                self.videoDelegate?.getVideo(videoArray:videoArray)
            }
        }
    }
    func searchGroup(text:String) {
        var groupArray = [TeamModel]()
        Ref.TeamRef.getDocuments { Snapshot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = Snapshot?.documents else { return }
            data.forEach { document in
                let safeData = document.data()
                let teamName = safeData["teamName"] as? String ?? ""
                let teamPlace = safeData["teamPlace"] as? String ?? ""
                if teamName.contains(text) || teamPlace.contains(text) {
                    let team = TeamModel(dic: safeData)
                    groupArray.append(team)
                }
            }
            self.groupSearchDelegate?.getGroup(groupArray: groupArray)
        }
    }
}


