import RxSwift
import Foundation

struct CircleRepositryImpl: CircleRepositry {
    
    func postCircle(id: String,
                    dic: [String: Any],
                    user: User,
                    memberId: [String],
                    completion: @escaping (Result<Void, Error>) -> Void) {
        
        Ref.CircleRef.document(id).setData(dic)
        
        let group = DispatchGroup()
        memberId.forEach { uid in
            group.enter()
            Ref.UsersRef.document(uid).collection("Circle").document(id).setData(["id": id]) { error in
                defer { group.leave() }
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
    
    static func getCircle(id: String, completion: @escaping(Circle) -> Void) {
        FirebaseClient.shared.getDataById(request: CircleTargetType(id: id), completion: completion)
    }
    
    func getMembers(ids: [String], circle: Circle) -> Single<Circle> {
        var data = circle
        let group = DispatchGroup()
        return Single.create { singleEvent in
            ids.forEach {
                group.enter()
                UserRepositryImpl.getUserById(uid: $0) { user in
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
            Ref.CircleRef.getDocuments { snapShot, error in
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
    
    func withdrawCircle(user: User,
                        circle: Circle,
                        completion: @escaping(Error?) -> Void) {
        let ids = circle.member.filter({ $0 != user.uid })
        
        Ref.CircleRef.document(circle.id).updateData(["member": ids],
                                                     completion: completion)
        
        Ref.UsersRef.document(user.uid).collection("Circle").document(circle.id).delete()
    }
    
    func updateCircle(circle: Circle, completion: @escaping(Error?) -> Void) {
        Ref.CircleRef.document(circle.id).updateData(["id": circle.id,
                                                      "name": circle.name,
                                                      "price": circle.price,
                                                      "place": circle.place,
                                                      "time": circle.time,
                                                      "features": circle.features,
                                                      "additionlText": circle.additionlText,
                                                      "icon": circle.icon,
                                                      "backGround": circle.backGround,
                                                      "member": circle.member],
                                                     completion: completion)
    }
    
    func inviteCircle(ids: [String],
                      circle: Circle,
                      completion: @escaping (Result<Void, Error>) -> Void) {
        
        Ref.CircleRef.document(circle.id).updateData(["member": ids])
        
        let group = DispatchGroup()
        ids.forEach { uid in
            group.enter()
            Ref.UsersRef.document(uid).collection("Circle").document(circle.id).setData(["id": circle.id]) { error in
                defer { group.leave() }
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
    
    func getCircle(id: String) -> Single<Circle> {
        FirebaseClient.shared.requesFirebase(request: CircleTargetType(id: id))
    }
}
