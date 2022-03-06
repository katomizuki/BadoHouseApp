import UIKit
import RxSwift
import RxCocoa

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
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.netError,
                              message: "",
                              action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.completed.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.popAnimation()
        }.disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.textViewInputs = text
        }).disposed(by: disposeBag)
    }

    @objc private func didTapNextButton() {
        viewModel.postPractice()
    }
    
    private func popAnimation() {
        // TODO: - 何かしらのFBが欲しいかも
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinator?.popToRoot()
        }
    }
}
