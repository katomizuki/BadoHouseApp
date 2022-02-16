import RxSwift

struct NotificationRepositryImpl: NotificationRepositry {
    
    static func postNotification(uid: String, dic: [String: Any]) -> Completable {
        let id = Ref.NotificationRef.document(uid).collection("Notification").document().documentID
        return Completable.create { observer in
            Ref.NotificationRef.document(uid).collection("Notification").document(id).setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func getMyNotification(uid: String) -> Single<[Notification]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: NotificationGetTargetType(id: uid))
    }
}
