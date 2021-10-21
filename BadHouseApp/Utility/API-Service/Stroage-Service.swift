import FirebaseStorage
import Firebase
import Foundation

struct StorageService {
    // Mark DownURL
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
    // Mark ProfileImageStorage
    static func addProfileImageToStorage(image: UIImage, dic: [String: Any], completion: @escaping() -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageUserImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                print("Image Save Error", error)
                return
            }
            print("Image Save Success")
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                var dicWithImage = dic
                dicWithImage["profileImageUrl"] = urlString
                UserService.updateUserData(dic: dicWithImage)
            }
        }
    }
    // Mark TeamImageAdd
    static func addTeamImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageTeamImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                print("Image Save Error", error)
                return
            }
            print("Image Save Succees")
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
    // Mark StorageAddImage
    static func addEventImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let upLoadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Ref.StorageEventImageRef.child(fileName)
        storageRef.putData(upLoadImage, metadata: nil) { _, error in
            if let error = error {
                print("Image Save Error", error)
                return
            }
            StorageService.downloadStorage(userIconRef: storageRef) { url in
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
    static func sendVideoData(videoUrl: URL, senderId: String, keyWord: String) {
        let id = UUID().uuidString
        let videoRef = Ref.StorageVideoRef.child(id)
        let metadata = StorageMetadata()
        metadata.contentType = "video/quickTime"
        if let videoData = NSData(contentsOf: videoUrl) as Data? {
            videoRef.putData(videoData, metadata: metadata) { _, error in
                if let error = error {
                    print(error)
                    return
                }
                videoRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let urlString = url?.absoluteString else { return }
                    let videoId = Ref.VideoRef.document().documentID
                    let dic = ["id": videoId,
                               "keyWord": keyWord,
                               "senderId": senderId,
                               "videoUrl": urlString] as [String: Any]
                    Ref.VideoRef.document(videoId).setData(dic) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                    }
                }
            }
        }
    }
}
