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
    
    func request<T:FirebaseSubCollectionTargetType>(request: T) -> Single<[T.Model]> {
        var models = [T.Model]()
        let group = DispatchGroup()
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
                        self.getDataById(ref: request.ref, id: request.id) { model in
                            
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
    private func getDataById<T: FirebaseModel>(ref:CollectionReference, id:String, completion:@escaping(T) -> Void) {
        ref.document(id).getDocument { snapShot, error in
            if error != nil {
                return
            }
            guard let dic = snapShot?.data() else { return }
            completion(T(dic: dic))
        }
    }

}
