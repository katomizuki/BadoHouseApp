import UIKit

final class CheckNotificationController: UIViewController {
    
    @IBOutlet private weak var notificationCollectionView: UICollectionView!
    var coordinator: NotificationCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    private func setupCollectionView() {
        notificationCollectionView.delegate = self
        notificationCollectionView.dataSource = self
        notificationCollectionView.register(NotificationCell.nib(), forCellWithReuseIdentifier: NotificationCell.id)
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        notificationCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }

}
extension CheckNotificationController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
extension CheckNotificationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.id, for: indexPath) as? NotificationCell else { fatalError() }
        return cell
    }
}

