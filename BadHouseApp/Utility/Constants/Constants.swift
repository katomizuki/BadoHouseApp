import Foundation
import UIKit

public struct Constants {
    static let appName = "バドハウス"
    struct AppColor {
        static let OriginalBlue: UIColor = .rgb(red: 124, green: 131, blue: 253, alpha: 1.0)
        static let darkColor = "backGroundColor"
    }
    struct Storyboard {
        static let LoginVC = "LoginVC"
        static let GroupDetailVC = "GroupDetailVC"
        static let UserDetailVC = "UserDetailVC"
        static let TagVC = "TagVC"
        static let EventDetailVC = "EventDetailVC"
        static let GroupChatVC = "GroupChatViewController"
        static let ChatVC = "ChatViewController"
        static let CameraVC = "CameraVC"
        static let inviteVC = "inviteVC"
        static let MakeGroupVC = "MakeGroupVC"
        static let TornamentDetailVC = "TornamentDetailVC"
        static let FriendVC = "FriendVC"
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
        static let gotoNotification = "gotoNotification"
        static let gotoSearch = "gotoSearch"
    }
    struct Cell {
        static let TeammemberCell = "TeammemberCell"
        static let GroupCell = "GroupCell"
        static let CollectionViewCell = "CollectionViewCell"
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
        static let popCellId = "popCellId"
        static let friendCellId = "friendCellId"
        static let videoCell = "videoCell"
    }
    struct ImageName {
        static let logoImage = "logo"
        static let double = "double"
        static let circle = "circle"
        static let check = "check"
        static let noImages = "noImages"
        static let reload = "reload"
        static let search = "search"
    }
    struct Data {
        static let tagArray = [
            "#急募","#複数人OK", "#ガチミントン", "#シングルス", "#ダブルス", "#ミックス", "#年齢不問",
            "#ジュニア", "#中高生歓迎", "#大学生", "#遅刻OK", "#ゲーム中心", "#練習もある", "#ジュニア歓迎",
            "#性別不問", "#楽しくワイワイ", "#コロナ対策有", "#同年代多め", "#レベル幅広く", "#金額安め", "#早退OK"]
        static let moneyArray = ["100", "200", "300", "400", "500", "600", "700", "800", "900",
                                 "1000", "1100", "1200", "1300", "1400", "1500", "1600", "1700",
                                 "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500",
                                 "2600", "2700", "2800", "2900", "3000"]
        static let userSection = ["居住地", "性別", "年代", "バドミントン歴", "レベル"]
        static let levelSentence = ["まだバドミントンを初めて半年以内。\n基本的なショットや素振りなどの練習をしている",
                                    "バドミントンを初めて半年から1年,\nほとんどのショットを簡単にできる。\n[小学校]スクールに通っていた",
                                    "バドミントンを初めて1年以上。\n簡単な試合ができる。\n[中学校,高校]部活動に入部していた時期がある。\n[大学]サークルの練習で稀に練習している（月に一度等）\n[社会人]サークルで練習している",
                            "シングルス、ダブルス共に試合ができる。\n[中学校,高校]いずれかで3年間在籍していた。\n[大学]サークルの練習で定期的に練習している（2週に1度以上）\n[社会人]サークルで練習しており、2年以上は在籍している", "試合を連続して行うことができる。\n[中学校,高校]6年間在籍していた\n[大学]サークルの練習で定期的に練習しており、バドミントン歴4年以上\n[社会人]サークルで練習しており,オープン大会2回戦~3回戦",  "[中学校,高校]地区大会入賞、県大会出場等の結果を残している。\n[大学]サークルの練習で定期的に練習しており、バドミントン歴6年以上\n[社会人]サークルで練習しており,オープン大会中級レベルで勝利したことがある",
                                    "[中学校,高校]地区大会上位、県大会入賞等の結果を残している。\n[大学]関東リーグ4部〜5部,体育会に4年間所属していた。\n[社会人]サークルで練習しており,オープン大会上級レベルで勝利したことがある",
                                    "[中学校,高校]県大会上位,関東大会入賞　\n[大学]関東リーグ3~4部\n[社会人]サークルで練習しており,オープン大会上級レベルで入賞したことがある",
                                    "[中学校,高校]全国大会出場　\n[大学]関東リーグ2~3部。\n[社会人]全日本社会人等の大きい大会で入賞したことがある",
                                    "全国大会入賞、上位、関東リーグ1部~2部。\n実業団に所属している等のバドミントン界のトッププレイヤー"
        ]
        static let yearArray = ["1年未満", "1年~3年", "4年~6年", "7年~10年", "10年以上"]
        static let ageArray = ["10代以下", "10代", "20代", "30代", "40代", "50代", "60代", "70代以上"]
        static let placeArray = ["神奈川県","東京都","千葉県","埼玉県"]
    }
}
// Mark Enum UserInfo
