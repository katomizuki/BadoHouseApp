import UIKit
protocol AddtionalPlaceFlow {
    func dismiss()
}
class AddtionalPlaceController: UIViewController {
    var coordinator: AddtionalPlaceFlow?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}