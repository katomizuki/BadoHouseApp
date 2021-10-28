import Foundation
enum Result<T,Error> {
    case success(T)
    case failure(Error)
}
enum FirebaseError:Error {
    case netError
}

