import RxSwift

struct ChatRepositryImpl: ChatRepositry {
    
    func getChat(chatId: String)->Single<[Chat]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: ChatGetTargetType(id: chatId))
     }
    
    func postChat(chatId: String, dic: [String: Any]) -> Completable {
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
