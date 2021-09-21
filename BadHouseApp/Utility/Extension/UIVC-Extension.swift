import Foundation
import UIKit
import Firebase

extension UIViewController {
    func showAlert(title:String,message:String,actionTitle:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func notification(uid:String,completion:@escaping(Bool)->Void) {
        Ref.UsersRef.document(uid).collection("PreJoin").addSnapshotListener { snapShot, error in
            var boolArray = [PreJoin]()
            var result = false
            if let error = error {
                print(error)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { data in
                let safeData = data.data()
                let id = safeData["id"] as? String ?? ""
                let alertOrNot = safeData["alertOrNot"] as? Bool ?? true
                let pre = PreJoin(id: id, alertOrNot: alertOrNot)
                boolArray.append(pre)
            }
            if boolArray.filter({ $0.alertOrNot == false }).count >= 1 {
                result = true
            }
            completion(result)
        }
    }
}

struct PreJoin {
    var id:String
    var alertOrNot:Bool
}

