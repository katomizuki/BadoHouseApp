import Firebase
import Domain

struct Circle: Equatable, FirebaseModel {
    typealias DomainModel = Domain.CircleModel
    var id: String
    var features: [String]
    var time: String
    var price: String
    var place: String
    var name: String
    var member: [String]
    var additionlText: String
    var backGround: String
    var icon: String
    var members = [User]()
    var charts: ChartsObject?
    var iconUrl: URL? {
        if let url = URL(string: icon) {
            return url
        } else {
            return nil
        }
    }
    var backGroundUrl: URL? {
        if let url = URL(string: backGround) {
            return url
        } else {
            return nil
        }
    }
    
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.features = dic["features"] as? [String] ?? []
        self.time = dic["time"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.place = dic["place"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.member = dic["member"] as? [String] ?? []
        self.additionlText = dic["additionlText"] as? String ?? ""
        self.backGround = dic["backGround"] as? String ?? ""
        self.icon = dic["icon"] as? String ?? ""
    }
    
    struct ChartsObject: Equatable {
        let members: [User]
        
        init(members: [User]) {
            self.members = members
        }
        
        func makeGenderPer() -> [Int] {
            var (men, women, other) = (0, 0, 0)
            self.members.forEach {
                switch $0.gender {
                case "男性":men += 1
                case "女性":women += 1
                default: other += 1
                }
            }
            return [men, women, other]
        }
        
        func makeLevelPer() -> [Int] {
            var (one, two, three, four, five, six, seven, eight, nine, ten) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
            self.members.forEach {
                switch $0.level {
                case "レベル1":one += 1
                case "レベル2":two += 1
                case "レベル3":three += 1
                case "レベル4":four += 1
                case "レベル5":five += 1
                case "レベル6":six += 1
                case "レベル7": seven += 1
                case "レベル8":eight += 1
                case "レベル9":nine += 1
                case "レベル10":ten += 1
                default: break
                }
            }
            return [one, two, three, four, five, six, seven, eight, nine, ten]
        }
    }
    
    func convertToModel() -> Domain.CircleModel {
        return Domain.CircleModel(id: self.id,
                                  features: self.features,
                                  time: self.time,
                                  price: self.price,
                                  place: self.place,
                                  name: self.name,
                                  memeber: self.member,
                                  additionlText: self.additionlText,
                                  backGround: self.backGround,
                                  icon: self.icon)
    }
}
