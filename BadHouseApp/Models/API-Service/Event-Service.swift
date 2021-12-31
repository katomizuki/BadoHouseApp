
struct PracticeServie {
    static func postPractice(dic:[String:Any],
                             circle:Circle,
                             user:User,
                             completion:@escaping(Error?)->Void) {
        var dictionary = dic
        dictionary["userId"] = user.uid
        dictionary["userName"] = user.name
        dictionary["circleId"] = circle.id
        dictionary["circleName"] = circle.name
        dictionary["userUrlString"] = user.profileImageUrlString
        dictionary["circleUrlString"] = circle.backGround
        let id = Ref.PracticeRef.document().documentID
        dictionary["id"] = id
        Ref.PracticeRef.document(id).setData(dictionary,completion: completion)
    }
}
