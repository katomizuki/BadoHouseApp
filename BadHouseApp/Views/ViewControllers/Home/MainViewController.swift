import UIKit
import Firebase
import RxCocoa
import RxSwift
import CoreLocation
import MapKit
import UserNotifications
import CDAlertView
protocol MainFlow: AnyObject {
    func toMap()
    func toMakeEvent()
    func toDetailSearch(_ vc:UIViewController)
    func toPracticeDetail()
    func toAuthentication(_ vc:UIViewController)
}
class MainViewController: UIViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    var (myLatitude, myLongitude) = (Double(), Double())
    private var eventArray = [Event]()
    private let cellId = "eventId"
    private var user: User?
    private let disposeBag = DisposeBag()
    var coordinator: MainFlow?
    @IBOutlet private weak var collectionView: UICollectionView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupDelegate()
        setupCollectionView()
        EventServie.deleteEvent()
        UIApplication.shared.applicationIconBadgeNumber = 0
        setupBinding()
        setupNavBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if !Network.shared.isOnline() {
            self.showCDAlert(title: "ネットワークがつながっておりません", message: "", action: "OK", alertType: .warning)
        }
        //        if Auth.auth().currentUser == nil {
        //            DispatchQueue.main.async {
        //                let vc = RegisterController.init(nibName: "RegisterController", bundle: nil)
        //                let nav = UINavigationController(rootViewController: vc)
        //                nav.modalPresentationStyle = .fullScreen
        //                self.present(nav, animated: true, completion: nil)
        
        //            }
        //        }
    }
    private func setupNavBarButton() {
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "location.north.circle.fill"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapMapButton))
        let detailSearchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapDetailSearchButton))
        let makeEventButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(didTapMakeEventButton))
        navigationItem.rightBarButtonItems = [detailSearchButton, mapButton]
        navigationItem.leftBarButtonItem = makeEventButton
        if #available(iOS 15.0, *) {
            navigationItem.leftBarButtonItem?.tintColor = .tintColor
        }
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = .tintColor
        }
    }
    @objc private func didTapMapButton() {
        coordinator?.toMap()
    }
    @objc private func didTapDetailSearchButton() {
        coordinator?.toDetailSearch(self)
    }
    @objc private func didTapMakeEventButton() {
        print(#function)
        coordinator?.toMakeEvent()
    }
    private func setupBinding() {
    }
    
    private func setupDelegate() {
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(EventInfoCell.nib(), forCellWithReuseIdentifier: EventInfoCell.id)
        collectionView.showsVerticalScrollIndicator = false
    }
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
}
// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventInfoCell.id, for: indexPath) as? EventInfoCell else { fatalError() }
        cell.delegate = self
        return cell
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 50)
    }
}
// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.toPracticeDetail()
    }
}
// MARK: - CLLOcationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else { return }
        guard let longitude = location?.coordinate.longitude else { return }
        myLatitude = latitude
        myLongitude = longitude
    }
}

// MARK: - EventInfoCellDelegate
extension MainViewController: EventInfoCellDelegate {
    func didTapBlockButton(_ cell: EventInfoCell) {
        guard let eventId = cell.event?.eventId else { return }
        let alertVC = UIAlertController(title: "コンテンツに不正な内容を発見した場合は通報またはブロックしてください", message: "", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "通報する", style: .default) { _ in
            print("通報")
            BlockService.sendBlockEventData(eventId: eventId) { result in
                switch result {
                case .success:
                    self.showCDAlert(title: "通報しました", message: "", action: "OK", alertType: .success)
                    guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                    self.eventArray.remove(at: indexPath[1])
                    self.collectionView.reloadData()
                case .failure(let error):
                    let message = self.setupFirestoreErrorMessage(error: error as! NSError)
                    self.showCDAlert(title: "通報に失敗しました", message: message, action: "OK", alertType: .warning)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
    }
}
