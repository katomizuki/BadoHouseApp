
import Firebase
protocol CircleServiceProtocol {
    
}
struct CircleService: CircleServiceProtocol {
   
    static func postCircle(id: String,
                           dic: [String: Any],
                           user: User,
                           memberId:[String],
                           completion: @escaping (Result<Void,Error>) -> Void) {
        Ref.TeamRef.document(id).setData(dic) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let group = DispatchGroup()
            memberId.forEach { uid in
                Ref.UsersRef.document(uid).collection("Circle").document(id).setData(["id" : id]) { error in
                    defer { group.enter() }
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
            }
            group.notify(queue: .main) {
                completion(.success(()))
            }
            
        }
    }
    static func getCircle(id: String, completion:@escaping(Circle)->Void) {
        Ref.TeamRef.document(id).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dic = snapshot?.data() else { return }
            let circle = Circle(dic: dic)
            completion(circle)
        }
    }
}
