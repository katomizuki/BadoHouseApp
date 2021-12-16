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
}
class MainViewController: UIViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    private var fetchData = FetchFirestoreData()
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
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
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
            self.setupCDAlert(title: "ネットワークがつながっておりません", message: "", action: "OK", alertType: .warning)
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
        fetchData.eventDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        let nib = UINib(nibName: "CollectionViewCell",
                        bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
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
        return eventArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventInfoCell
        cell.delegate = self
        if eventArray.isEmpty {
            return cell
        } else {
            let event = eventArray[indexPath.row]
            cell.event = event
            return cell
        }
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
        let controller = PracticeDetailController.init(nibName: "PracticeDetailController", bundle: nil)
        controller.event = eventArray[indexPath.row]
        let teamId = eventArray[indexPath.row].teamId
        TeamService.getTeamData(teamId: teamId) { team in
            controller.team = team
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
        fetchData.fetchEventData(latitude: myLatitude, longitude: myLongitude)
    }
}
// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
                setupCDAlert(title: "検索エラー",
                              message: "１文字以上入力してください",
                              action: "OK",
                              alertType: CDAlertViewType.error)
            return
        }
        fetchData.searchEventTextData(text: searchText, bool: true)
        searchBar.resignFirstResponder()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let text = searchBar.text else { return }
        if searchBar.text == "" {
            fetchData.fetchEventData(latitude: myLatitude, longitude: myLongitude)
            searchBar.resignFirstResponder()
        } else {
            fetchData.searchEventTextData(text: text, bool: false)
        }
    }
}
// MARK: - FetchEventDataDelegate
extension MainViewController: FetchEventDataDelegate {
    func fetchEventData(eventArray: [Event]) {
        print(#function)
        self.eventArray = eventArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func fetchEventTimeData(eventArray: [Event]) {
        print(#function)
        if eventArray.isEmpty {
        } else {
            self.eventArray = eventArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    func fetchDetailData(eventArray: [Event]) {
        print(#function)
        self.eventArray = eventArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func fetchEventSearchData(eventArray: [Event], bool: Bool) {
        print(#function)
        self.eventArray = eventArray
        if bool == false {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else if bool == true {
            if eventArray.isEmpty {
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
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
                    self.setupCDAlert(title: "通報しました", message: "", action: "OK", alertType: .success)
                    guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                    self.eventArray.remove(at: indexPath[1])
                    self.collectionView.reloadData()
                case .failure(let error):
                    let message = self.setupFirestoreErrorMessage(error: error as! NSError)
                    self.setupCDAlert(title: "通報に失敗しました", message: message, action: "OK", alertType: .warning)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
    }
}
