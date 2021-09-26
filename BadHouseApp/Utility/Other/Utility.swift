import Foundation
import UIKit

struct Utility {
    static let appName = "バドハウス"
    
    struct AppColor {
        static let StandardColor:UIColor = .rgb(red: 136, green: 237, blue: 247, alpha: 1.0)
        static let OriginalBlue:UIColor = .rgb(red:124, green:131,blue: 253,alpha: 1.0)
        static let OriginalLightBlue:UIColor = .rgb(red: 150, green: 186, blue: 255)
        static let OriginalPastelBlue:UIColor = .rgb(red: 127, green: 237, blue: 257)
    }

 
    struct Storyboard {
        static let LoginVC = "LoginVC"
        static let GroupDetailVC = "GroupDetailVC"
        static let UserDetailVC = "UserDetailVC"
        static let TagVC = "TagVC"
        static let EventDetailVC = "EventDetailVC"
    }
    struct Segue {
        static let gotoRegister = "gotoRegister"
        static let gotoUser = "gotoUser"
        static let gotoMakeGroup = "gotoMakeGroup"
        static let gotoCalendar = "gotoCalendar"
        static let gotoDetail = "gotoDetail"
        static let gotoGroup = "gotoGroup"
        static let gotoInvite = "gotoInvite"
        static let gotoChatRoom = "gotoChatRoom"
        static let groupChat = "groupChat"
        static let gotoLevel = "gotoLevel"
        static let gotoChat = "gotoChat"
        static let gotoDM = "DM"
        static let goWalk = "goWalk"
    }
    struct Cell {
        static let TeammemberCell = "TeammemberCell"
        static let GroupCell = "GroupCell"
    }
    
    struct CellId {
        static let FriendCellId = "cellFriendId"
        static let CellGroupId = "cellGroupId"
        static let MemberCellId = "memberCellId"
        static let eventId = "eventId"
        static let inviteCellId = "inviteCellId"
        static let userCellId = "userCellId"
        static let searchCell = "searchCell"
        static let chatCellId = "chatCellId"
    }
    
    struct ImageName {
        static let swift = "swift-og"
        static let logoImage = "swift-og"
        static let double = "double"
    }
}



