import UIKit
import SDWebImage
import RxSwift
import RxCocoa

 final class MainUserDetailController: UIViewController {
    // MARK: - Properties
     private let viewModel: UserDetailViewModel
     @IBOutlet private weak var ageLabel: UILabel!
     @IBOutlet private weak var genderLabel: UILabel!
     @IBOutlet private weak var talkButton: UIButton! {
         didSet {
             talkButton.layer.borderWidth = 1
             talkButton.layer.borderColor = UIColor.systemBlue.cgColor
             talkButton.changeCorner(num: 5)
             talkButton.setTitle("", for: .normal)
         }
     }
     @IBOutlet private weak var levelLabel: UILabel!
     @IBOutlet private weak var placeLabel: UILabel!
     @IBOutlet private weak var racketLabel: UILabel!
     @IBOutlet private weak var playerLabel: UILabel!
     @IBOutlet private weak var textView: UITextView!
     @IBOutlet private weak var badmintonTimeLabel: UILabel!
     @IBOutlet private weak var applyFriendButton: UIButton! {
         didSet {
             applyFriendButton.changeCorner(num: 5)
             applyFriendButton.layer.borderColor = UIColor.systemBlue.cgColor
             applyFriendButton.layer.borderWidth = 1
         }
     }
     @IBOutlet private weak var userImageView: UIImageView! {
         didSet {
             userImageView.changeCorner(num: 30)
         }
     }
     @IBOutlet private weak var friendsButton: UIButton! {
         didSet {
             friendsButton.changeCorner(num: 5)
             friendsButton.layer.borderColor = UIColor.systemBlue.cgColor
             friendsButton.layer.borderWidth = 1
         }
     }
     @IBOutlet private weak var circleCollectionView: UICollectionView!
     @IBOutlet private weak var nameLabel: UILabel!
     var coordinator: MainUserDetailFlow?
     private let disposeBag = DisposeBag()
     
     init(viewModel: UserDetailViewModel) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError()
     }
     // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      setupCollectionView()
      setupNavigationBar()
      setupUI()
      setupBinding()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
        viewModel.willAppear()
    }
     
     private func setupCollectionView() {
         circleCollectionView.register(UserCircleCell.nib(), forCellWithReuseIdentifier: UserCircleCell.id)
     }
     
     private func setupNavigationBar() {
         let rightBarButton = UIBarButtonItem(title: "...", style: .done, target: self, action: #selector(didTapExpandedMenu))
         navigationItem.rightBarButtonItem = rightBarButton
     }
     
     private func setupUI() {
         ageLabel.text = viewModel.user.age
         genderLabel.text = viewModel.user.gender
         levelLabel.text = viewModel.user.level
         placeLabel.text = viewModel.user.place
         racketLabel.text = viewModel.user.racket
         playerLabel.text = viewModel.user.player
         nameLabel.text = viewModel.user.name
         textView.text = viewModel.user.introduction
         badmintonTimeLabel.text = viewModel.user.badmintonTime
         applyFriendButton.isHidden = viewModel.isApplyButtonHidden
         talkButton.isHidden = viewModel.isTalkButtonHidden
         userImageView.sd_setImage(with: viewModel.user.profileImageUrl)
     }
     
     private func setupBinding() {
         
         viewModel.outputs.applyButtonString.subscribe {[weak self] text in
             self?.applyFriendButton.setTitle(text, for: .normal)
         }.disposed(by: disposeBag)

         viewModel.outputs.friendListRelay.subscribe(onNext: { [weak self] users in
             self?.friendsButton.setTitle("バド友 \(users.count)人", for: .normal)
         }).disposed(by: disposeBag)
         
         circleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
         
         viewModel.outputs.circleListRelay.bind(to: circleCollectionView.rx.items(cellIdentifier: UserCircleCell.id, cellType: UserCircleCell.self)) { _, item, cell in
             cell.configure(item)
         }.disposed(by: disposeBag)
         
         circleCollectionView.rx.itemSelected.bind(onNext: {[weak self] indexPath in
             guard let self = self else { return }
             self.coordinator?.toCircleDetail(myData: self.viewModel.myData,
                                              circle: self.viewModel.circleListRelay.value[indexPath.row])
         }).disposed(by: disposeBag)
         
         viewModel.outputs.reload.subscribe { [weak self] _ in
             self?.circleCollectionView.reloadData()
         }.disposed(by: disposeBag)
         
         viewModel.outputs.completed.subscribe { [weak self] _ in
             guard let self = self else { return }
             self.applyFriendButton.setTitle(R.buttonTitle.alreadyApply, for: .normal)
             self.showCDAlert(title: R.alertMessage.applyFriend, message: "", action: R.alertMessage.ok, alertType: .success)
         }.disposed(by: disposeBag)
         
         viewModel.outputs.notApplyedCompleted.subscribe { [weak self] _ in
             self?.applyFriendButton.setTitle(R.buttonTitle.apply, for: .normal)
             self?.showCDAlert(title: R.alertMessage.noApplyFriend, message: "", action: R.alertMessage.ok, alertType: .success)
         }.disposed(by: disposeBag)
     }
  
    // MARK: - Selector
     @objc private func didTapExpandedMenu() {
         let alertVC = AlertProvider.makeAlertVC(viewModel.user) { [weak self] error in
             if error != nil {
                 self?.showCDAlert(title: R.alertMessage.netError, message: "", action: R.alertMessage.ok, alertType: .error)
                 return
             }
             self?.showCDAlert(title: R.alertMessage.block, message: "", action: R.alertMessage.ok, alertType: .success)
         }
         present(alertVC, animated: true)
     }
     
    // MARK: - IBAction
     @IBAction private func didTapBadmintonFriend(_ sender: Any) {
         coordinator?.toFriendList(
            friends: viewModel.friendListRelay.value,
            myData: viewModel.myData)
     }
     
     @IBAction func didTapTalkButton(_ sender: Any) {
             self.coordinator?.toChat(
                myData: self.viewModel.myData,
                user: self.viewModel.user)
     }
     
     @IBAction func didTapApplyFriendButton(_ sender: UIButton) {
         if sender.titleLabel?.text == R.alertMessage.applyFriend {
             viewModel.inputs.applyFriend()
         } else {
             viewModel.inputs.notApplyedFriend()
         }
     }
 }

extension MainUserDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
