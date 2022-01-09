import UIKit
import RxSwift

protocol FriendListFlow:AnyObject {
    func toUserDetail(myData:User,user:User)
}
final class FriendsListController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var friendListTableView: UITableView!
    var coordinator: FriendListFlow?
    private let viewModel: FriendsListViewModel
    private let disposeBag = DisposeBag()
    init(viewModel:FriendsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        navigationItem.backButtonDisplayMode = .minimal
    }
    private func setupBinding() {
        friendListTableView.register(MemberCell.nib(), forCellReuseIdentifier: MemberCell.id)
        friendListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.usersRelay.bind(to: friendListTableView.rx.items(cellIdentifier: MemberCell.id, cellType: MemberCell.self)) {_, item, cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        friendListTableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toUserDetail(myData: self.viewModel.myData,
                                           user: self.viewModel.usersRelay.value[indexPath.row])
        }).disposed(by: disposeBag)
    }
}
