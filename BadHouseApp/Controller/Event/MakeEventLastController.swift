import UIKit
import RxSwift
import RxCocoa

class MakeEventLastController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
            textView.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var makeEventButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavAccessory()
    }
    private func setupBinding() {
        makeEventButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
