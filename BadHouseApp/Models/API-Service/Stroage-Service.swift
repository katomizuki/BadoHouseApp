import FirebaseStorage
import Firebase

struct StorageService {
    // MARK: - DownloadUrl
    static func downloadStorage(userIconRef: StorageReference, completion: @escaping (URL) -> Void) {
        userIconRef.downloadURL { url, error in
            if let error = error {
                print(error)
                return
            }
            guard let url = url else { return }
            completion(url)
        }
    }
    // MARK: - ProfileImageStorage
    static func addProfileImageToStorage(image: UIImage, dic: [String: Any], completion: @escaping(Result<String, Error>) -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageUserImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                var dicWithImage = dic
                dicWithImage["profileImageUrl"] = urlString
        }
    }
 }
    // MARK: - TeamImageAdd
    static func addTeamImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageTeamImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                return
            }
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
    // MARK: - addEventImage
    static func addEventImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageEventImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                return
            }
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    } 
    static func setupStorageErrorMessage(error: NSError) -> String {
        var message = ""
        let storageError = StorageErrorCode(rawValue: error.code)
        switch storageError {
        case .cancelled: message = "何らかの理由でアップロードがキャンセルされました"
        case .downloadSizeExceeded: message = "サイズが大きかったのでアップロードできませんでした"
        case .retryLimitExceeded: message = "アップロードに時間がかかったのでキャンセルしました"
        default: message = "原因不明のエラーでアップロードができませんでした"
        }
        return  message
    }
}
