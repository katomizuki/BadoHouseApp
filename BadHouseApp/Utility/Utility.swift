
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
        

    }
    struct Cell {
        static let TeammemberCell = "TeammemberCell"
        static let BelongTeamCell = "BelongTeamCollectionCell"
        static let GroupCell = "GroupCell"
        static let CollectionViewCell = "CollectionViewCell"
     
    }
    struct CellId {
        static let FriendCellId = "cellFriendId"
        static let CellGroupId = "cellGroupId"
        static let MemberCellId = "memberCellId"
        static let BelongTeamId = "belongTeamId"
        static let eventId = "eventId"
    }
    struct ImageName {
        static let swift = "swift-og"
        static let logoImage = "swift-og"
    }
    
   
}

extension UIColor {
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1)->UIColor {
        return .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
extension UINavigationItem {
    func setBackBarButton() {
        let backItem  = UIBarButtonItem(title: "もどる", style: .plain, target: nil, action: nil)
        backItem.tintColor = Utility.AppColor.OriginalBlue
        self.backBarButtonItem = backItem
    }
}
