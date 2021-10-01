import Foundation
import UIKit
import Firebase
import NVActivityIndicatorView
import CDAlertView

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
                let pre = PreJoin(dic:safeData)
                boolArray.append(pre)
            }
            if boolArray.filter({ $0.alertOrNot == false }).count >= 1 {
                result = true
            }
            completion(result)
        }
    }
    
    func setupIndicatorView()->NVActivityIndicatorView {
        let frame = CGRect(x: view.frame.width / 2,
                           y: view.frame.height / 2,
                           width: 100,
                           height: 100)
        return  NVActivityIndicatorView(frame: frame,
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
    }
    
    func setupCDAlert(title:String,message:String,action:String,alertType:CDAlertViewType) {
        let alert = CDAlertView(title: title, message: message, type: alertType)
        let alertAction = CDAlertViewAction(title: action, font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
        
        alert.add(action: alertAction)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            print("completed")
        }
    }
    
    func formatterUtil(date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func setupErrorMessage(error:NSError)->String {
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
        let image = UIImage(named: Utility.ImageName.double)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:Utility.AppColor.OriginalBlue]
    }
    
    
}



