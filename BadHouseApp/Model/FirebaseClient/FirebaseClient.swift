//
//  FirebaseClient.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/19.
//

import RxSwift
import FirebaseFirestore

class FirebaseClient {
    static let shared = FirebaseClient()
    func requesFirebase<T:FirebaseTargetType>(request: T) -> Single<T.Model> {
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).getDocument { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    guard let dic = snapShot.data() else { return }

                    let model = T.Model(dic: dic)
                        singleEvent(.success(model))
                }
            }
            return Disposables.create()
        }
    }
    
    func requestFirebaseSubCollection<T: FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model]> {
        var models = [T.Model]()
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
                                models.append(model)
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
    
    func getFirebaseSubData<T: FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model]> {
        return Single.create { singleEvent -> Disposable in
            request.ref.document(request.id).collection(request.subCollectionName).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                let models = snapShot.documents.map { T.Model(dic: $0.data()) }
                singleEvent(.success(models))
            }
            return Disposables.create()
        }
    }
}
