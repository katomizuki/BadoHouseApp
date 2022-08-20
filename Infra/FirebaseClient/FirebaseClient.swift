import RxSwift
import FirebaseFirestore

class FirebaseClient {
    
    static let shared = FirebaseClient()
    
    func requesFirebase<T: FirebaseTargetType>(request: T) -> Single<T.Model.DomainModel> {
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).getDocument { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    guard let dic = snapShot.data() else { return }
                    
                    let model = T.Model(dic: dic).convertToModel()
                    singleEvent(.success(model))
                }
            }
            return Disposables.create()
        }
    }
    
    func requestFirebaseSubCollection<T: FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model.DomainModel]> {
        var models = [T.Model.DomainModel]()
        let group = DispatchGroup()
        let blockIds: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "blocks")
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).collection(request.subCollectionName).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        group.enter()
                        let id = $0.data()["id"] as? String ?? ""
                        request.subRef.document(id).getDocument { snapShot, error in
                            if let error = error {
                                singleEvent(.failure(error))
                                return
                            }
                            defer { group.leave() }
                            guard let dic = snapShot?.data() else { return }
                            let model = T.Model(dic: dic)
                            if !blockIds.contains(id) {
                                models.append(model.convertToModel())
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        singleEvent(.success(models))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func requestFirebaseSubData<T: FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model.DomainModel]> {
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).collection(request.subCollectionName).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                singleEvent(.success(snapShot.documents.map { T.Model(dic: $0.data()).convertToModel() }))
            }
            return Disposables.create()
        }
    }
    
    func requestFirebaseSortedSubData<T: FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model.DomainModel]> {
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).collection(request.subCollectionName).order(by: request.sortField, descending: request.isDescending!).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let documents = snapShot?.documents else { return }
                singleEvent(.success(documents.map { T.Model(dic: $0.data()).convertToModel() }))
            }
            return Disposables.create()
        }
    }
    
    func requestFirebaseSort<T: FirebaseTargetType>(request: T) -> Single<[T.Model.DomainModel]> {
        return Single.create { singleEvent in
            request.ref.getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                singleEvent(.success(snapShot.documents.map { T.Model(dic: $0.data()).convertToModel() }))
            }
            return Disposables.create()
        }
    }
    
    func getDataById<T: FirebaseTargetType>(request: T,
                                            completion: @escaping(T.Model.DomainModel) -> Void) {
        request.ref.document(request.id).getDocument { snapShot, error in
            if error != nil { return }
            if let dic = snapShot?.data() {
                completion(T.Model(dic: dic).convertToModel())
            }
        }
    }
    
    func getDataById<T: FirebaseSubCollectionTargetType>(request: T,
                                                         completion: @escaping(T.Model.DomainModel) -> Void) {
        request.ref.document(request.id).collection(request.subCollectionName).document(request.subId).getDocument { snapShot, error in
            if error != nil { return }
            if let dic = snapShot?.data() {
                completion(T.Model(dic: dic).convertToModel())
            }
        }
    }
    
    func postFirebaseData<T: FirebaseSubCollectionTargetType>(targetType: T, dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            targetType.ref.document(targetType.id).collection(targetType.subCollectionName).document(targetType.subId).setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func updateFirebaseData<T: FirebaseTargetType>(targetType: T, dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            targetType.ref.document(targetType.id).updateData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
}
