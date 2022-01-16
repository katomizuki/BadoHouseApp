import Firebase
import RxSwift
protocol ChatServiceProtocol {
    func getChat(chatId: String)->Single<[Chat]>
    func postChat(chatId: String,
                  dic: [String: Any],
                  completion: @escaping(Error?) -> Void)
}
struct ChatService: ChatServiceProtocol {
    
    func getChat(chatId: String)->Single<[Chat]> {
        return Single.create { singleEvent->Disposable in
            Ref.ChatRef.document(chatId).collection("Comment").order(by: "createdAt", descending: false)
                .getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                let chats = snapShot.documents.map { Chat(dic: $0.data()) }
                singleEvent(.success(chats))
            }
            return Disposables.create()
        }
     }
    
    func postChat(chatId: String, dic: [String: Any],
                  completion: @escaping(Error?) -> Void) {
        let id = Ref.ChatRef.document(chatId).collection("Comment").document().documentID
        Ref.ChatRef.document(chatId).collection("Comment").document(id).setData(dic, completion: completion)
    }
    
}
