import Foundation

struct Tag {
    var tag: String
    var tagId: String
    init?(dic: [String: Any]) {
        guard let tag = dic["tag"] as? String,
              let tagId = dic["tagId"] as? String else { return nil }
        self.tag = tag
        self.tagId = tagId
    }
}
