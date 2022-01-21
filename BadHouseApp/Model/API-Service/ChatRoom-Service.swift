import RxSwift

protocol ChatServiceProtocol {
    func getChat(chatId: String)->Single<[Chat]>
    func postChat(chatId: String,
                  dic: [String: Any],
                  completion: @escaping(Error?) -> Void)
}
struct ChatService: ChatServiceProtocol {
    
    func getChat(chatId: String)->Single<[Chat]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: ChatGetTargetType(id: chatId))
     }
    
    func postChat(chatId: String, dic: [String: Any],
                  completion: @escaping(Error?) -> Void) {
        Ref.ChatRef.document(chatId).collection("Comment").document(Ref.ChatRef.document(chatId).collection("Comment").document().documentID).setData(dic, completion: completion)
    }
}
