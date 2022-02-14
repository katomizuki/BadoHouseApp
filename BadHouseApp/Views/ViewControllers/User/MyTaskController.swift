import UIKit
import RxSwift
import RxCocoa

final class MyTaskController: UIViewController {
    
    private let viewModel: MyTaskViewModel
    var coordinator: MyTaskFlow?
    
    init(viewModel: MyTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
