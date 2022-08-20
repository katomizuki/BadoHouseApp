import RxSwift
import Foundation
import Domain

public struct CircleRepositryImpl: CircleRepositry {
    public init() { }
    public func postCircle(id: String,
                    dic: [String: Any],
                    user: Domain.UserModel,
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
    
    public static func getCircle(id: String, completion: @escaping(Domain.CircleModel) -> Void) {
        FirebaseClient.shared.getDataById(request: CircleTargetType(id: id), completion: completion)
    }
    
    public func getMembers(ids: [String], circle: Domain.CircleModel) -> Single<Domain.CircleModel> {
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
    
    public func searchCircles(text: String) -> Single<[Domain.CircleModel]> {
        var circles = [Domain.CircleModel]()
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
                        circles.append(circle.convertToModel())
                    }
                }
                singleEvent(.success(circles))
            }
            return Disposables.create()
        }
    }
    
    public func withdrawCircle(user: Domain.UserModel,
                        circle: Domain.CircleModel) -> Completable {
        let ids = circle.member.filter({ $0 != user.uid })
        return Completable.create { observer in
            Ref.CircleRef.document(circle.id).updateData(["member": ids]) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    public func updateCircle(circle: Domain.CircleModel) -> Completable {
        let dic: [String: Any] = ["id": circle.id,
                                  "name": circle.name,
                                  "price": circle.price,
                                  "place": circle.place,
                                  "time": circle.time,
                                  "features": circle.features,
                                  "additionlText": circle.additionlText,
                                  "icon": circle.icon,
                                  "backGround": circle.backGround,
                                  "member": circle.member]
        return FirebaseClient.shared.updateFirebaseData(targetType: UpdateCircleTargetType(id: circle.id), dic: dic)
    }
    
    public func inviteCircle(ids: [String],
                      circle: Domain.CircleModel,
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
    
    public func getCircle(id: String) -> Single<Domain.CircleModel> {
        FirebaseClient.shared.requesFirebase(request: CircleTargetType(id: id))
    }
}
