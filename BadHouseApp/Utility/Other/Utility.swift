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
        static let gotoInvite = "gotoInvite"
        static let gotoLevel = "gotoLevel"
        static let gotoChat = "gotoChat"
        static let goWalk = "goWalk"
        static let gotoMap = "gotoMap"
        static let userProfile = "userProfile"
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
        static let logoImage = "logo"
        static let double = "double"
    }
    
    struct Data {
        static let circle = ["学生サークル", "社会人サークル", "その他練習"]
        static let place = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                            "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                            "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                            "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                            "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                            "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                            "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
        static let money = ["500円~1000円","1000円~2000円","2000円~"]
        static let level = ["レベル1","レベル2","レベル3","レベル4","レベル5","レベル6","レベル7","レベル8","レベル9","レベル10"]
    }
}



