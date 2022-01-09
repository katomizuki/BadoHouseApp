import UIKit

final class ProblemInformationController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "不具合報告"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "報告", style: .done, target: self, action: #selector(didTapRightButton))
    }
    @objc private func didTapRightButton() {
        let id = Ref.ReportRef.document().documentID
        guard let text = textView.text else { return }
        textView.text = ""
        Ref.ReportRef.document(id).setData(["problem": text])
        self.showCDAlert(title: "報告ありがとうございます！", message: "", action: "OK", alertType: .success)
    }
}
