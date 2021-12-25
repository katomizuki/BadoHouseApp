import UIKit
import RxSwift
import RxCocoa
protocol EventAdditionlItemsFlow {
    func popToRoot()
}
final class EventAdditionlItemsController: UIViewController {
    private let disposeBag = DisposeBag()
    var coordinator: EventAdditionlItemsFlow?
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.systemBlue.cgColor
            textView.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var makeEventButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        makeEventButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.coordinator?.popToRoot()
        }).disposed(by: disposeBag)
    }
}
