import Foundation

struct Tag {
    var tag: String
    var tagId: String
    init(dic: [String: Any]) {
        self.tag = dic["tag"] as? String ?? ""
        self.tagId = dic["tagId"] as? String ?? ""
    }
}
