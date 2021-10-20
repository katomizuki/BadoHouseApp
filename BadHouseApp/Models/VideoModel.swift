import Foundation

struct VideoModel {
    let keyWord: String
    let senderId: String
    let thumnailUrl: String
    let videoUrl: String
    let videoId: String
    init(dic: [String: Any]) {
        self.keyWord = dic["keyWord"] as? String ?? ""
        self.senderId = dic["senderId"] as? String ?? ""
        self.thumnailUrl = dic["thumnailUrl"] as? String ?? ""
        self.videoUrl = dic["videoUrl"] as? String ?? ""
        self.videoId = dic["videoId"] as? String ?? ""
    }
}
