
import Firebase
import RxSwift
protocol CircleServiceProtocol {
    func getMembers(ids: [String], circle: Circle) -> Single<Circle>
    func searchCircles(text: String) -> Single<[Circle]>
}
struct CircleService: CircleServiceProtocol {
   
    static func postCircle(id: String,
                           dic: [String: Any],
                           user: User,
                           memberId:[String],
                           completion: @escaping (Result<Void,Error>) -> Void) {
        Ref.TeamRef.document(id).setData(dic) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let group = DispatchGroup()
            memberId.forEach { uid in
                Ref.UsersRef.document(uid).collection("Circle").document(id).setData(["id" : id]) { error in
                    defer { group.enter() }
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
            }
            group.notify(queue: .main) {
                completion(.success(()))
            }
            
        }
    }
    static func getCircle(id: String, completion:@escaping(Circle)->Void) {
        Ref.TeamRef.document(id).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dic = snapshot?.data() else { return }
            let circle = Circle(dic: dic)
            completion(circle)
        }
    }
    
    func getMembers(ids: [String], circle: Circle) -> Single<Circle> {
        var data = circle
        let group = DispatchGroup()
        return Single.create { singleEvent in
            ids.forEach {
                group.enter()
                UserService.getUserById(uid: $0) { user in
                    defer { group.leave() }
                    data.members.append(user)
                }
            }
            group.notify(queue: .main) {
                singleEvent(.success(data))
            }
            return Disposables.create()
        }
    }
    
    func searchCircles(text: String) -> Single<[Circle]> {
        var circles = [Circle]()
        return Single.create { singleEvent-> Disposable in
            Ref.TeamRef.getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                snapShot.documents.forEach {
                    let circle = Circle(dic: $0.data())
                    if circle.name.contains(text) || circle.place.contains(text) {
                        circles.append(circle)
                    }
                }
                singleEvent(.success(circles))
            }
            return Disposables.create()
        }
    }
    static func updateCircle(user:User,
                             circle: Circle,
                             completion: @escaping (Error?)->Void) {
        let ids = circle.member.filter({ $0 != user.uid })
        Ref.TeamRef.document(circle.id).updateData(["member" : ids],
                                                   completion: completion)
    }
}
