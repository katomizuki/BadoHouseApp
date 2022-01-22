import UIKit

final class ProblemInformationController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.navTitle.problem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.buttonTitle.report, style: .done, target: self, action: #selector(didTapRightButton))
    }
    
    @objc private func didTapRightButton() {
        let id = Ref.ReportRef.document().documentID
        guard let text = textView.text else { return }
        textView.text = ""
        Ref.ReportRef.document(id).setData(["problem": text])
        self.showCDAlert(title: R.alertMessage.thankYou, message: "", action: R.alertMessage.ok, alertType: .success)
    }
}
