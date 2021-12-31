import UIKit
protocol AddtionalPlaceFlow {
    func dismiss()
}
class AddtionalPlaceController: UIViewController {
    var coordinator: AddtionalPlaceFlow?
    
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                    target: self,
                                                    action: #selector(didTapRightButton))
    }
    @objc private func didTapRightButton() {
        dismiss(animated: true)
    }
}
