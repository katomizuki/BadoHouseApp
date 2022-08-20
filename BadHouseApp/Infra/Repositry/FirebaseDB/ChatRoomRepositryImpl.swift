import RxSwift
import Domain

public struct ChatRepositryImpl: ChatRepositry {
    public init() { }
    public func getChat(chatId: String)->Single<[Domain.ChatModel]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: ChatGetTargetType(id: chatId))
     }
    
    public func postChat(chatId: String, dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            Ref.ChatRef.document(chatId).collection("Comment").document(Ref.ChatRef.document(chatId).collection("Comment").document().documentID).setData(dic) { error in
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
