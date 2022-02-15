import UIKit
import RxSwift
import RxCocoa

final class MyPracticeController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: MyPracticeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPracticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.practices.bind(to: tableView.rx.items(cellIdentifier: CustomCell.id, cellType: CustomCell.self)) { _, item, cell in
            cell.configure(practice: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.bind(onNext: {[weak self] indexPath in
            let alertVC = AlertProvider.practiceAlertVC()
            guard let self = self else { return }
            let gatherAction = UIAlertAction(title: R.buttonTitle.stopPractice, style: .destructive) {  _ in
                self.viewModel.inputs.deletePractice(self.viewModel.practices.value[indexPath.row])
            }
            alertVC.addAction(gatherAction)
            self.present(alertVC, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.navigationController?.pushViewController(PracticeDetailController.init(viewModel: PracticeDetailViewModel(practice: self.viewModel.practices.value[indexPath.row],
                                        userAPI: UserRepositryImpl(),
                                        circleAPI: CircleRepositryImpl(),
                                        isModal: false,
                                        joinAPI: JoinRepositryImpl())), animated: true)
        }).disposed(by: disposeBag)
    }
}
