import Foundation
import EmptyStateKit

enum State: CustomState {
    // Mark case
    case noNotifications
    case noSearch
    case noInternet
    // Mark Properties
    var image: UIImage? {
        switch self {
        case .noNotifications: return UIImage(named: "Messages")
        case .noSearch: return UIImage(named: "sad")
        case .noInternet: return UIImage(named: "Internet")
        }
    }
    var title: String? {
        switch self {
        case .noNotifications: return "No message notifications"
        case .noSearch: return "検索結果が0件でした"
        case .noInternet: return "We’re Sorry"
        }
    }
    var description: String? {
        switch self {
        case .noNotifications: return "Sorry, you don't have any message. Please come back later!"
        case .noSearch: return "他の条件で検索してください。"
        case .noInternet: return "Our staff is still working on the issue for better experience"
        }
    }
    var titleButton: String? {
        switch self {
        case .noNotifications: return "Search again?"
        case .noSearch: return "もどる"
        case .noInternet: return "Try again?"
        }
    }
}
