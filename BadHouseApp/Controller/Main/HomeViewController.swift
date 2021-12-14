import UIKit
import Firebase
import RxCocoa
import RxSwift
import CoreLocation
import MapKit
import UserNotifications
import CDAlertView

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    private var fetchData = FetchFirestoreData()
    var (myLatitude, myLongitude) = (Double(), Double())
    private var eventArray = [Event]()
    private let cellId = "eventId"
    private var user: User?
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var makeEventButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet private weak var detailSearchButton: UIButton!
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if !Network.shared.isOnline() {
            self.setupCDAlert(title: "ネットワークがつながっておりません", message: "", action: "OK", alertType: .warning)
        }
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = RegisterViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    private func setupBinding() {
        makeEventButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let controller = AdditionalEventTitleController.init(nibName: "AdditionalEventTitleController", bundle: nil)
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        detailSearchButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let controller = EventSearchController.init(nibName: "EventSearchController", bundle: nil)
            self?.present(controller, animated: true)
        }).disposed(by: disposeBag)
        mapButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let controller = MapListController.init(nibName: "MapListController", bundle: nil)
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
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
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Segue.gotoUser.rawValue {
            let vc = segue.destination as! UserPageController
            vc.user = self.user
        }

    }
    // MARK: IBAction
    @IBAction private func scroll(_ sender: Any) {
        print(#function)
        if eventArray.count != 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
}
// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
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
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 50)
    }
}
// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerID.EventDetailVC) as! EventDetailController
        vc.event = eventArray[indexPath.row]
        let teamId = eventArray[indexPath.row].teamId
        TeamService.getTeamData(teamId: teamId) { team in
            vc.team = team
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - CLLOcationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
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
extension HomeViewController: UISearchBarDelegate {
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
extension HomeViewController: FetchEventDataDelegate {
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
extension HomeViewController: EventInfoCellDelegate {
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
