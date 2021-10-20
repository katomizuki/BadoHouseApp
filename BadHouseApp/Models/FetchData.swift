import Foundation
import Firebase
import CoreLocation
import RxSwift

protocol FetchGenderCountDataDelegate: AnyObject {
    func fetchGenderCount(countArray: [Int])
    func fetchBarData(countArray: [Int])
}
protocol FetchEventDataDelegate: AnyObject {
    func fetchEventData(eventArray: [Event])
    func getEventSearchData(eventArray: [Event], bool: Bool)
    func getEventTimeData(eventArray: [Event])
    func getDetailData(eventArray: [Event])
}
protocol FetchMyChatDataDelgate: AnyObject {
    func fetchMyChatData(chatArray: [Chat])
    func fetchMyChatRoomData(chatRoomArray: [ChatRoom])
    func fetchMyChatListData(userArray: [User],
                             anotherArray: [User],
                             lastChatArray: [Chat],
                             chatModelArray: [ChatRoom])
}
protocol FetchSearchUserDataDelegate: AnyObject {
    func fetchSearchUser(userArray: [User], bool: Bool)
}
protocol FetchMyGroupChatDataDelegate: AnyObject {
    func fetchMyGroupChatData(groupChatModelArray: [GroupChatModel])
}
protocol FetchMyPrejoinDataDelegate: AnyObject {
    func fetchMyPrejoinData(preJoinArray: [[String]])
}
protocol FetchMyJoinDataDelegate: AnyObject {
    func fetchMyJoinData(joinArray: [[String]])
}
protocol FetchVideoDataDelegate: AnyObject {
    func fetchVideoData(videoArray: [VideoModel])
}
protocol FetchSearchGroupDelegate: AnyObject {
    func fetchSearchGroup(groupArray: [TeamModel], bool: Bool)
}
protocol FetchMyEventDataDelegate: AnyObject {
    func fetchMyEventData(eventArray: [Event])
}
protocol FetchMyTeamDataDelegate: AnyObject {
    func fetchMyTeamData(teamArray: [TeamModel])
}
protocol FetchMyFriendDataDelegate: AnyObject {
    func fetchMyFriendData(friendArray: [User])
}
class FetchFirestoreData {
    // Mark Delegate
    weak var chartsDelegate: FetchGenderCountDataDelegate?
    weak var eventDelegate: FetchEventDataDelegate?
    weak var chatDelegate: FetchMyChatDataDelgate?
    weak var userSearchDelegate: FetchSearchUserDataDelegate?
    weak var groupChatDataDelegate: FetchMyGroupChatDataDelegate?
    weak var preJoinDelegate: FetchMyPrejoinDataDelegate?
    weak var joinDelegate: FetchMyJoinDataDelegate?
    weak var videoDelegate: FetchVideoDataDelegate?
    weak var groupSearchDelegate: FetchSearchGroupDelegate?
    weak var myEventDelegate: FetchMyEventDataDelegate?
    weak var myTeamDelegate: FetchMyTeamDataDelegate?
    weak var myFriendDelegate: FetchMyFriendDataDelegate?
    // Mark FetchFriendData
    func fetchMyFriendData(idArray: [String]) {
        let group = DispatchGroup()
        var array = [User]()
        for i in 0..<idArray.count {
            group.enter()
            let uid = idArray[i]
            UserService.getUserData(uid: uid) { friend in
                defer {
                    group.leave()
                }
                guard let friend = friend else { return }
                array.append(friend)
            }
        }
        group.notify(queue: .main) {
            self.myFriendDelegate?.fetchMyFriendData(friendArray: array)
        }
    }
    // Mark fetchMyTeamData
    func fetchMyTeamData(idArray: [String]) {
        var teamArray = [TeamModel]()
        let group = DispatchGroup()
        idArray.forEach { id in
            group.enter()
            Ref.TeamRef.document(id).getDocument { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                defer { group.leave() }
                guard let data = snapShot?.data() else { return }
                let team = TeamModel(dic: data)
                teamArray.append(team)
            }
        }
        group.notify(queue: .main) {
            self.myTeamDelegate?.fetchMyTeamData(teamArray: teamArray)
        }
    }
    // Mark FetchMyEventData
    func fetchMyEventData(idArray: [String]) {
        var eventArray = [Event]()
        let group = DispatchGroup()
        idArray.forEach { id in
            group.enter()
            Ref.EventRef.document(id).getDocument { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                defer { group.leave() }
                guard let data = snapShot?.data() else { return }
                let event = Event(dic: data)
                eventArray.append(event)
            }
        }
        group.notify(queue: .main) {
            self.myEventDelegate?.fetchMyEventData(eventArray: eventArray)
        }
    }
    // Mark fetchChatlistData
    func fetchMyChatListData(chatModelArray: [ChatRoom]) {
        var userArray = [User]()
        var anotherArray = [User]()
        var lastCommentArray = [Chat]()
        for i in 0..<chatModelArray.count {
            let userId = chatModelArray[i].user
            let anotherId = chatModelArray[i].user2
            let chatId = chatModelArray[i].chatRoom
            UserService.getUserData(uid: userId) { user in
                guard let user = user else { return }
                userArray.append(user)
            }
            UserService.getUserData(uid: anotherId) { another in
                guard let another = another else { return }
                anotherArray.append(another)
            }
            ChatRoomService.getChatLastData(chatId: chatId) { lastComment in
                lastCommentArray.append(lastComment)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.chatDelegate?.fetchMyChatListData(userArray: userArray,
                                                   anotherArray: anotherArray,
                                                   lastChatArray: lastCommentArray,
                                                   chatModelArray: chatModelArray)
        }
    }
    // Mark fetchGenderCount
    func fetchGenderCountData(teamPlayers: [User]) {
        var manCount = 0
        var womanCount = 0
        var otherCount = 0
        let group = DispatchGroup()
        for i in 0..<teamPlayers.count {
            group.enter()
            let playerId = teamPlayers[i].uid
            UserService.getUserData(uid: playerId) { user in
                guard let gender = user?.gender else { return }
                defer { group.leave() }
                if gender == "男性" {
                    manCount += 1
                } else if gender == "女性" {
                    womanCount += 1
                } else {
                    otherCount += 1
                }
            }
        }
        group.notify(queue: .main) {
            self.chartsDelegate?.fetchGenderCount(countArray: [manCount, womanCount, otherCount])
        }
    }
    // Mark FetchEventData
    func fetchEventData(latitude: Double, longitude: Double) {
        Ref.EventRef.addSnapshotListener { snapShot, error in
            var eventArray = [Event]()
            if let error = error {
                print("EventData", error)
            }
            guard let data = snapShot?.documents else { return }
            eventArray = []
            data.forEach { doc in
                let safeData = doc.data() as [String: Any]
                let leaderId = safeData["userId"] as? String ?? ""
                if leaderId != AuthService.getUserId() {
                    let event = Event(dic: safeData)
                    eventArray.append(event)
                }
            }
            self.sortEventDate(data: eventArray,
                               latitude: latitude,
                               longitude: longitude)
        }
    }
    // Mark FetchDMChat
    func fetchDMChatData(chatId: String) {
        Ref.ChatroomRef.document(chatId).collection("Content").order(by: "sendTime").addSnapshotListener { snapShot, error in
            var chatArray = [Chat]()
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { doc in
                let data = doc.data()
                let chat = Chat(dic: data)
                chatArray.append(chat)
            }
            self.chatDelegate?.fetchMyChatData(chatArray: chatArray)
        }
    }
    // Mark fetchChatroomData
    func fetchChatRoomModelData(chatId: [String]) {
        var chatRoomModelArray = [ChatRoom]()
        let group = DispatchGroup()
        for i in 0..<chatId.count {
            group.enter()
            Ref.ChatroomRef.document(chatId[i]).getDocument { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                defer { group.leave() }
                guard let data = snapShot?.data() else { return }
                let chatRoomModel = ChatRoom(dic: data)
                chatRoomModelArray.append(chatRoomModel)
            }
        }
        group.notify(queue: .main) {
            self.chatDelegate?.fetchMyChatRoomData(chatRoomArray: chatRoomModelArray)
        }
    }
    // Mark fetchGroupChat
    func fetchGroupChatData(teamId: String) {
        var groupChat = [GroupChatModel]()
        Ref.TeamRef.document(teamId).collection("GroupChat").order(by: "timeStamp").addSnapshotListener { snapShot, error in
            if let error = error {
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
            self.groupChatDataDelegate?.fetchMyGroupChatData(groupChatModelArray: groupChat)
        }
    }
    // Mark FetchEventPrejoinData
    func fetchEventPreJoinData(eventArray: [Event]) {
        var stringArray = [[String]]()
        let group = DispatchGroup()
        for i in 0..<eventArray.count {
            group.enter()
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
                defer { group.leave() }
                stringArray.append(tempArray)
            }
        }
        group.notify(queue: .main) {
            self.preJoinDelegate?.fetchMyPrejoinData(preJoinArray: stringArray)
        }
    }
    // Mark FetchEventJoin
    func fetchEventJoinData(eventArray: [Event]) {
        var stringArray = [[String]]()
        let group = DispatchGroup()
        for i in 0..<eventArray.count {
            group.enter()
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
                defer { group.leave() }
                stringArray.append(tempArray)
            }
        }
        group.notify(queue: .main) {
            self.joinDelegate?.fetchMyJoinData(joinArray: stringArray)
        }
    }
    // Mark FetchVideoData
    func fetchVideoData() {
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
            self.videoDelegate?.fetchVideoData(videoArray: array)
        }
    }
    // Mark sortEventDate
    func sortEventDate(data: [Event], latitude: Double, longitude: Double) {
        var data = data
        data = data.sorted(by: {
            $0.eventStartTime.compare($1.eventStartTime) == .orderedAscending
        })
        guard let now = DateUtils.getNow() else { return }
        data = data.filter { event in
            let dateString = event.eventStartTime
            let dateData = DateUtils.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z") ?? now
            let time = event.eventTime
            let eventTime = DateUtils.dateFromString(string: time, format: "yyyy/MM/dd HH:mm:ss Z") ?? now
            return dateData >= now && eventTime >= now
        }
        for i in 0..<data.count {
            let eventLatitude = data[i].latitude
            let eventLongitude = data[i].longitude
            let currentPosition: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let eventPosition: CLLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
            let distance = currentPosition.distance(from: eventPosition)
            data[i].distance = distance
        }
        data = data.sorted(by: {
            $0.distance < $1.distance
        })
        self.eventDelegate?.fetchEventData(eventArray: data)
    }
    // Mark searchEventTextData
    func searchEventTextData(text: String, bool: Bool) {
        var eventArray = [Event]()
        Ref.EventRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else {return}
            data.forEach { doc in
                let safeData = doc.data()
                let placeAddress = safeData["placeAddress"] as? String ?? ""
                let place = safeData["place"] as? String ?? ""
                let teamName = safeData["teamName"] as? String ?? ""
                let kindCircle = safeData["kindCircle"] as? String ?? ""
                let eventTitle = safeData["eventTitle"] as? String ?? "バドハウス"
                if placeAddress.contains(text) || place.contains(text) || teamName.contains(text) || kindCircle.contains(text) || eventTitle.contains(text) {
                    let event = Event(dic: safeData)
                    eventArray.append(event)
                }
            }
            self.eventDelegate?.getEventSearchData(eventArray: eventArray, bool: bool)
        }
    }
    // Mark searchEventDateData
    func searchEventDateData(dateString: String, text: String) {
        var eventArray = [Event]()
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 0)
        let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
        let keyDate = String(dateString[startIndex..<endIndex])
        Ref.EventRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safeData = doc.data()
                let eventStartTime = safeData["eventStartTime"] as? String ?? ""
                let firstIndex = eventStartTime.index(eventStartTime.startIndex, offsetBy: 0)
                let lastIndex = eventStartTime.index(eventStartTime.startIndex, offsetBy: 10)
                let startTimeString = String(eventStartTime[firstIndex..<lastIndex])
                if startTimeString == keyDate {
                    let event = Event(dic: safeData)
                    eventArray.append(event)
                }
            }
            eventArray = eventArray.filter { $0.placeAddress.contains(text) || $0.eventPlace.contains(text) }
            self.eventDelegate?.getEventTimeData(eventArray: eventArray)
        }
    }
    // Mark searchEventDetailData
    func searchEventDetailData(title: String,
                               circle: String,
                               level: String,
                               placeAddressString: String,
                               money: String,
                               time: String) {
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
                eventArray = eventArray.filter { $0.kindCircle == circle }
            }
            if placeAddressString != "" {
                eventArray = eventArray.filter { $0.placeAddress.contains(placeAddressString) }
            }
            if money != "" {
                eventArray = self.searchMoneyData(money: money, events: eventArray)
            }
            if level != "" {
                eventArray = self.searchLevelData(searchLevel: level, event: eventArray)
            }
            if time != "" {
                eventArray = self.searchTimeData(time: time, event: eventArray)
            }
            self.eventDelegate?.getDetailData(eventArray: eventArray)
        }
    }
    // Mark searchMoneyData
    func searchMoneyData(money: String, events: [Event]) -> [Event] {
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
    // Mark searchLevelData
    func searchLevelData(searchLevel: String, event: [Event]) -> [Event] {
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
    // Mark searchTimeData
    func searchTimeData(time: String, event: [Event]) -> [Event] {
        print(#function)
        var eventArray = [Event]()
        eventArray = event.filter { $0.eventStartTime == time }
        return eventArray
    }
    // Mark searchVideoData
    func searchVideoData(text: String) {
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
                self.videoDelegate?.fetchVideoData(videoArray: array)
            } else {
                videoArray = Array(videoArray[0..<3])
                self.videoDelegate?.fetchVideoData(videoArray: videoArray)
            }
        }
    }
    // Mark searchGroupData
    func searchGroupData(text: String, bool: Bool) {
        var groupArray = [TeamModel]()
        Ref.TeamRef.getDocuments { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { document in
                let safeData = document.data()
                let teamName = safeData["teamName"] as? String ?? ""
                let teamPlace = safeData["teamPlace"] as? String ?? ""
                if teamName.contains(text) || teamPlace.contains(text) {
                    let team = TeamModel(dic: safeData)
                    groupArray.append(team)
                }
            }
            self.groupSearchDelegate?.fetchSearchGroup(groupArray: groupArray, bool: bool)
        }
    }
    // Mark searchFriends
    func searchFriends(text: String, bool: Bool) {
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
                if name.contains(text) && id != AuthService.getUserId() {
                    let user = User(dic: safeData)
                    userArray.append(user)
                }
            }
            self.userSearchDelegate?.fetchSearchUser(userArray: userArray, bool: bool)
        }
    }
    // Mark searchTeamPlayerLevelcount
    func searchTeamPlayerLevelCount(teamPlayers: [User]) {
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
            case BadmintonLevel.one.rawValue:
                level1 += 1
            case BadmintonLevel.two.rawValue:
                level2 += 1
            case BadmintonLevel.three.rawValue:
                level3 += 1
            case BadmintonLevel.four.rawValue:
                level4 += 1
            case BadmintonLevel.five.rawValue:
                level5 += 1
            case BadmintonLevel.six.rawValue:
                level6 += 1
            case BadmintonLevel.seven.rawValue:
                level7 += 1
            case BadmintonLevel.eight.rawValue:
                level8 += 1
            case BadmintonLevel.nine.rawValue:
                level9 += 1
            case BadmintonLevel.ten.rawValue:
                level10 += 1
            default:
                break
            }
        }
        self.chartsDelegate?.fetchBarData(countArray: [level1,
                                                       level2,
                                                       level3,
                                                       level4,
                                                       level5,
                                                       level6,
                                                       level7,
                                                       level8,
                                                       level9,
                                                       level10])
    }
}
