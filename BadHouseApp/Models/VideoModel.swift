import Foundation

struct VideoModel {
    let keyWord: String
    let senderId: String
    var videoUrl: URL?
    let videoId: String
    init?(dic: [String: Any]) {
        guard let keyWord = dic["keyWord"] as? String,
              let senderId = dic["senderId"] as? String,
              let videoId = dic["id"] as? String else { return nil }
        self.keyWord = keyWord
        self.senderId = senderId
        self.videoId = videoId
        if let videoUrl = dic["videoUrl"] as? String {
            guard let url = URL(string: videoUrl) else { return nil }
            self.videoUrl = url
        }
    }
}
