import Foundation
import UIKit
import Firebase
import NVActivityIndicatorView
import CDAlertView
// Mark UIViewcontroller-Extension
extension UIViewController {
    func setupIndicatorView() -> NVActivityIndicatorView {
        let frame = CGRect(x: view.frame.width / 2,
                           y: view.frame.height / 2,
                           width: 100,
                           height: 100)
        return  NVActivityIndicatorView(frame: frame,
                                        type: NVActivityIndicatorType.ballSpinFadeLoader,
                                        color: Constants.AppColor.OriginalBlue,
                                        padding: 0)
    }
    func setupCDAlert(title: String, message: String, action: String, alertType: CDAlertViewType) {
        let alert = CDAlertView(title: title, message: message, type: alertType)
        let alertAction = CDAlertViewAction(title: action, font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
        alert.add(action: alertAction)
        alert.hideAnimations = { (_, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show()
    }
    func formatterUtil(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateString = formatter.string(from: date)
        return dateString
    }
    func setupErrorMessage(error: NSError) -> String {
        var message = ""
        if let errCode = AuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .invalidEmail:      message =  "有効なメールアドレスを入力してください"
            case .emailAlreadyInUse: message = "既に登録されているメールアドレスです"
            case .weakPassword:      message = "パスワードは６文字以上で入力してください"
            case .userNotFound:  message = "アカウントが見つかりませんでした"
            case .wrongPassword: message = "パスワードを確認してください"
            case .userDisabled:  message = "アカウントが無効になっています"
            default:                 message = "エラー: \(error.localizedDescription)"
            }
        }
        return message
    }
    func setupFirestoreErrorMessage(error:NSError) -> String {
        var message = ""
        if let errCode = FirestoreErrorCode(rawValue: error.code) {
            switch errCode {
            case .cancelled:
                message = "データの送信がキャンセルされました"
            case .OK:
                message = "データの送信に成功しました"
            case .unknown:
                message = "原因不明のエラーです"
            case .invalidArgument:
                message = "不正なデータが与えられました"
            case .deadlineExceeded:
                message = "サーバー側で問題が起きました。大変申し訳ございませんが再度送信をよろしくお願い致します"
            case .notFound:
                message = "不正なデータが送られまし"
            case .permissionDenied:
                message = "こちらの操作をするには認証が必要です。"
            case .resourceExhausted:
                message = "データの容量が超えてしまいました。"
            case .unimplemented:
                message = "何らかの理由で実行できませんでした。"
            default:
                message = "原因不明のエラーです。"
            }
        }
        return message
    }
    func setupNavAccessory() {
        let image = UIImage(named: Constants.ImageName.double)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.tintColor = Constants.AppColor.OriginalBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.AppColor.OriginalBlue]
    }
    func performSegue(segue: Segue,sender:AnyObject?) {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}
