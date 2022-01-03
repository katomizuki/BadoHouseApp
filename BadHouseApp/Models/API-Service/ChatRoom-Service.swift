import Firebase
import RxSwift
protocol ChatServiceProtocol {
    func getChat(chatId: String)->Single<[Chat]>
    func postChat(chatId:String, dic:[String: Any],completion:@escaping(Error?)->Void)
}
struct ChatService:ChatServiceProtocol {
    func getChat(chatId: String)->Single<[Chat]> {
        var chats = [Chat]()
        return Single.create { singleEvent->Disposable in
            Ref.ChatRef.document(chatId).collection("Comment").order(by: "createdAt", descending: true)
                .getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                snapShot.documents.forEach {
                    let dic = $0.data()
                    let chat = Chat(dic: dic)
                    chats.append(chat)
                }
                singleEvent(.success(chats))
            }
            return Disposables.create()
        }
     }
    func postChat(chatId:String, dic:[String: Any],completion:@escaping(Error?)->Void) {
        let id = Ref.ChatRef.document(chatId).collection("Comment").document().documentID
        Ref.ChatRef.document(chatId).collection("Comment").document(id).setData(dic,completion: completion)
    }
}
