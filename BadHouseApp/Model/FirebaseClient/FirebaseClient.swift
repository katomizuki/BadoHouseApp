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

}
