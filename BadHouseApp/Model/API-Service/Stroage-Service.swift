import FirebaseStorage
import Firebase

struct StorageService {
    // MARK: - DownloadUrl
    static func downloadStorage(userIconRef: StorageReference,
                                completion: @escaping (URL) -> Void) {
        userIconRef.downloadURL { url, error in
            if error != nil { return }
            guard let url = url else { return }
            completion(url)
        }
    }
    static func downLoadImage(image: UIImage,
                              completion: @escaping(Result<String, Error>) -> Void) {
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageUserImageRef.child(fileName)
        storageRef.putData(uploadImage, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(.success(urlString))
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
