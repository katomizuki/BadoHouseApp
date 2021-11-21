import Foundation
protocol SegueType {
    var rawValue: String { get }
}
enum Segue: String, SegueType {
    case gotoRegister
    case gotoUser
    case gotoMakeGroup
    case gotoCalendar
    case gotoDetail
    case gotoInvite
    case gotoLevel
    case gotoChat
    case goWalk
    case gotoMap
    case userProfile
    case gotoNotification
    case gotoSearch
}
