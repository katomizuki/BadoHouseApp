import UIKit
import Domain
import Infra

final class AlertProvider {
    
    static func makeAlertVC(_ user: Domain.UserModel,
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
    static func makeCancleVC(_ viewModel: ScheduleViewModel, row: Int) -> UIAlertController {
        let alertVC = UIAlertController(title: "練習をキャンセルしますか?", message: "必ず、主催者にチャットで確認をしてから行ってください", preferredStyle: .actionSheet)
        let backAction = UIAlertAction(title: "閉じる", style: .cancel)
        let cancleAction = UIAlertAction(title: "キャンセルする", style: .destructive) { _ in
            viewModel.inputs.deleteSchdule(row)
        }
        alertVC.addAction(backAction)
        alertVC.addAction(cancleAction)
        return alertVC
    }
    
    static func postAlertVC(_ practice: Domain.Practice,
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
