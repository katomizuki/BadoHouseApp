import UIKit
import RxSwift
import RxCocoa
import PKHUD
protocol EventAdditionlItemsFlow {
    func popToRoot()
}
final class EventAdditionlItemsController: UIViewController {
    private let disposeBag = DisposeBag()
    var coordinator: EventAdditionlItemsFlow?
    var viewModel:EventAdditionalItemViewModel!
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
        
        viewModel.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.completed.subscribe { [weak self] _ in
            self?.popAnimation()
        }.disposed(by: disposeBag)
    }
    @IBAction func didTapPracticeButton(_ sender: Any) {
        viewModel.postPractice()
    }
    private func popAnimation() {
        HUD.show(.success, onView: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinator?.popToRoot()
        }
    }
    
}
