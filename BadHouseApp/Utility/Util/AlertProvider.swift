import UIKit

final class AlertProvider {
    
    static func makeAlertVC(_ user: User,
                            completion: @escaping(Error?) -> Void) -> UIAlertController {
        let alertVC = UIAlertController(title: "このユーザーに関して", message: "", preferredStyle: .actionSheet)
        let problemAction = UIAlertAction(title: "不適切なユーザーである", style: .destructive) {  _ in
            Ref.ReportRef.document(user.uid).setData(["id": user.uid],
                                                     completion: completion)
        }

        let canleAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alertVC.addAction(problemAction)
        alertVC.addAction(canleAction)
        return alertVC
    }
    
    static func postAlertVC(_ practice: Practice,
                            completion: @escaping(Error?)->Void)->UIAlertController {
        let alertVC = UIAlertController(title: "この投稿に関して", message: "", preferredStyle: .actionSheet)
        let problemAction = UIAlertAction(title: "不適切な投稿である", style: .destructive) {  _ in
            Ref.ReportRef.document(practice.id).setData(["id": practice.id], completion: completion)
        }
        let canleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(problemAction)
        alertVC.addAction(canleAction)
        return alertVC
    }
    
    static func practiceAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "この練習に関して", message: "", preferredStyle: .actionSheet)
        let canleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(canleAction)
        return alertVC
    }
}
