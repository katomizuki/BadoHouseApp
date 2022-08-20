import UIKit
import RxSwift
import SDWebImage
import Domain

final class SearchUserController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    private let viewModel: SearchUserViewModel
    var coordinator: SearchUserFlow?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    
    init(viewModel: SearchUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupTableView() {
        userTableView.rowHeight = 50
        userTableView.register(SearchUserCell.nib(), forCellReuseIdentifier: SearchUserCell.id)
    }
    
    private func setupBinding() {
        userTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().subscribe(onNext: { [weak self] text in
                self?.viewModel.inputs.searchTextInput.onNext(text)
            }).disposed(by: disposeBag)
        
        viewModel.outputs.usersRelay.bind(to: userTableView.rx.items(cellIdentifier: SearchUserCell.id, cellType: SearchUserCell.self)) {_, item, cell in
            cell.configure(item)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        userTableView.rx.itemSelected.asDriver().drive { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toUserDetail(self.viewModel.outputs.usersRelay.value[indexPath.row], self.viewModel.user)
        }.disposed(by: disposeBag)
    }
}

extension SearchUserController: SearchUserCellDelegate {
    func searchUserCellNotApply(_ user: Domain.UserModel,
                                cell: SearchUserCell) {
        viewModel.notApplyFriend(user,
                                 myData: viewModel.user)
    }
    func searchUserCellApply(_ user: Domain.UserModel,
                             cell: SearchUserCell) {
        viewModel.applyFriend(user,
                              myData: viewModel.user)
    }
}
