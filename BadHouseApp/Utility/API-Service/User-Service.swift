import Foundation
import Firebase

struct UserService {
    //Mark: setUserData
    static func setUserData(uid:String,password:String,email:String,name:String,completion:@escaping (Bool) ->()) {
        let dic = ["uid":uid,
                   "name":name,
                   "email":email,
                   "createdAt":Timestamp(),
                   "updatedAt":Timestamp()] as [String : Any]
        Ref.UsersRef.document(uid).setData(dic) { error in
            if let error = error {
                print("SetUserData",error)
            }
            completion(true)
            print("setUserData")
        }
    }
    
    //Mark UserDataUpdate
    static func updateUserInfo(dic:[String:Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(uid).updateData(dic) { error in
            if let error = error {
                print("更新エラー",error)
                return
            }
            print("更新成功")
        }
    }
    
    //Mark: UserDataGet
    static func getUserData(uid:String,compeltion:@escaping (User?)->Void) {
        Ref.UsersRef.document(uid).addSnapshotListener { snapShot, error in
            if let error = error {
                print("UserInfo Get Error",error)
                return
            }
            guard let dic = snapShot?.data() else { return }
            let user = User(dic: dic)
            compeltion(user)
        }
    }
}
