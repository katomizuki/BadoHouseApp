import FirebaseFirestore
import RxSwift

protocol NotificationServiceProtocol {
    func getMyNotification(uid: String)->Single<[Notification]>
}
struct NotificationService: NotificationServiceProtocol {
    
    static func postNotification(uid: String, dic: [String : Any], completion: @escaping (Error?) -> Void) {
        let id = Ref.NotificationRef.document(uid).collection("Notification").document().documentID
        Ref.NotificationRef.document(uid).collection("Notification").document(id).setData(dic,completion: completion)
    }
    func getMyNotification(uid: String) -> Single<[Notification]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: NotificationGetTargetType(id: uid))
    }
}
