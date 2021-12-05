import UIKit
import RxCocoa
import RxSwift
final class MakeEventThirdController: UIViewController {
    @IBOutlet private weak var nextButton: UIButton!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavAccessory()
    }
    private func setupBinding() {
        nextButton.rx.tap.asDriver().drive(onNext: { _  in
            let storyboard = UIStoryboard(name: "MakeEvent", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "MakeEventLastController") as? MakeEventLastController else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
    }
}
