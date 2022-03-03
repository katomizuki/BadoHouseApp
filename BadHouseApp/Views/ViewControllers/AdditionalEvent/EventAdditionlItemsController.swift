import UIKit
import RxSwift
import RxCocoa
import PKHUD

final class EventAdditionlItemsController: UIViewController {
    
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.systemBlue.cgColor
            textView.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var makeEventButton: UIButton!

    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: R.buttonTitle.post, style: .done, target: self, action: #selector(didTapNextButton))
        return button
    }()
    private let disposeBag = DisposeBag()
    private let viewModel: EventAdditionalItemViewModel

    var coordinator: EventAdditionlItemsFlow?

    init(viewModel: EventAdditionalItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = R.navTitle.four
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupBinding() {
        
        viewModel.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok, alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.completed.subscribe { [weak self] _ in
            self?.popAnimation()
        }.disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.subscribe(onNext: {[weak self] text in
            self?.viewModel.textViewInputs = text
        }).disposed(by: disposeBag)
    }

    @objc private func didTapNextButton() {
        viewModel.postPractice()
    }
    
    private func popAnimation() {
        HUD.show(.success, onView: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinator?.popToRoot()
        }
    }
}
