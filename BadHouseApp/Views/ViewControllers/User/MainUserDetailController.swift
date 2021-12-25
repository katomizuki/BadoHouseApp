
import UIKit
protocol MainUserDetailFlow: AnyObject {
    func toCircleDetail()
    func toFriendList()
}
 final class MainUserDetailController: UIViewController {
    // MARK: - Properties
     @IBOutlet private weak var applyFriendButton: UIButton! {
         didSet {
             applyFriendButton.layer.cornerRadius = 5
             applyFriendButton.layer.masksToBounds = true
             applyFriendButton.layer.borderColor = UIColor.systemBlue.cgColor
             applyFriendButton.layer.borderWidth = 1
         }
     }
     @IBOutlet private weak var userImageView: UIImageView! {
         didSet {
             userImageView.layer.cornerRadius = 30
             userImageView.layer.masksToBounds = true
         }
     }
     @IBOutlet private weak var circleCollectionView: UICollectionView!
     var coordinator:MainUserDetailFlow?
     // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      setupCollectionView()
      setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
    }
     private func setupCollectionView() {
         circleCollectionView.delegate = self
         circleCollectionView.dataSource = self
         circleCollectionView.register(UserCircleCell.nib(), forCellWithReuseIdentifier: UserCircleCell.id)
     }
     private func setupNavigationBar() {
         let rightBarButton = UIBarButtonItem(title: "...", style: .done, target: self, action: #selector(didTapExpandedMenu))
         navigationItem.rightBarButtonItem = rightBarButton
     }
  
    // MARK: - Selector
     @objc private func didTapExpandedMenu() {
         
     }
    // MARK: - IBAction
     @IBAction private func didTapBadmintonFriend(_ sender: Any) {
         coordinator?.toFriendList()
         let controller = FriendsListController.init(nibName: R.nib.friendsListController.name, bundle: nil)
         navigationController?.pushViewController(controller, animated: true)
     }
     
}
extension MainUserDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        coordinator?.toCircleDetail()
        let controller = CircleDetailController.init(nibName: R.nib.circleDetailController.name, bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
extension MainUserDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCircleCell.id, for: indexPath) as? UserCircleCell else { fatalError() }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
extension MainUserDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
