import UIKit
import RxSwift
import RxCocoa
class MakeEventSecondController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavAccessory()
    }
    private func setupBinding() {
        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let storyboard = UIStoryboard(name: "MakeEvent", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "MakeEventThirdController") as? MakeEventThirdController else { return }
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)

    }
}
