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
    func setupNavAccessory() {
        let image = UIImage(named: Constants.ImageName.double)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.tintColor = Constants.AppColor.OriginalBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.AppColor.OriginalBlue]
    }
}
// Mark UIImageView Extension
extension UIImageView {
    func chageCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
// Mark UIColor-Extension
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
// Mark Array-Extension
extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
