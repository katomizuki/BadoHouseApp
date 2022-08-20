public protocol FirebaseModel {
     init(dic: [String: Any])
    associatedtype DomainModel

    func convertToModel() -> DomainModel 
}
