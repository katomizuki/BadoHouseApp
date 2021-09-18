import Foundation
import UIKit

extension UIViewController {
    func showAlert(title:String,message:String,actionTitle:String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
}
