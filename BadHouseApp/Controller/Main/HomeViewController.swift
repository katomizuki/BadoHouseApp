import UIKit
import Firebase
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import CoreLocation
import MapKit
import EmptyStateKit
import UserNotifications
import CDAlertView
import FacebookCore

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private var user: User?
    private var indicatorView: NVActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var locationManager: CLLocationManager!
    private var fetchData = FetchFirestoreData()
    var (myLatitude, myLongitude) = (Double(), Double())
    private var eventArray = [Event]()
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = Constants.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Constants.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var tornmentSearchButton: UIButton! {
        didSet { tornmentSearchButton.setTitle("大会検索", for: .normal)}
    }
    @IBOutlet weak var timeButton: UIButton! {
        didSet {
            timeButton.toCorner(num: 15)
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        indicatorView.startAnimating()
        setupLocationManager()
        setupDelegate()
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
        setupCollectionView()
        setupEmptyState()
        EventServie.deleteEvent()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if !Network.shared.isOnline() {
            print("ネットワークないよ！")
            self.setupCDAlert(title: "ネットワークがつながっておりません", message: "", action: "OK", alertType: .warning)
        }
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segue.gotoRegister, sender: nil)
            }
        }
    }

    // MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // MARK: - setupMethod
    private func setupEmptyState() {
        view.emptyState.delegate = self
        var format = EmptyStateFormat()
        format.buttonColor = Constants.AppColor.OriginalBlue
        format.buttonWidth = 200
        format.titleAttributes = [.foregroundColor: Constants.AppColor.OriginalBlue]
        format.descriptionAttributes = [.strokeWidth: -5, .foregroundColor: UIColor.darkGray]
        format.animation = EmptyStateAnimation.scale(0.3, 2.0)
        format.imageSize = CGSize(width: 200, height: 200)
        format.backgroundColor = UIColor(named: Constants.AppColor.darkColor) ?? UIColor.systemGray
        view.emptyState.format = format
    }
    private func setupDelegate() {
        fetchData.eventDelegate = self
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupIndicator() {
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        let nib = UINib(nibName: Constants.Cell.CollectionViewCell,
                        bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.CellId.eventId)
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
        if segue.identifier ==  Constants.Segue.gotoUser {
            let vc = segue.destination as! MyPageUserInfoController
            vc.user = self.user
        }
        if segue.identifier == Constants.Segue.gotoCalendar {
            let vc = segue.destination as! SearchCalendarController
            vc.delegate = self
        }
        if segue.identifier == Constants.Segue.gotoDetail {
            let vc = segue.destination as! DetailSearchController
            vc.delegate = self
        }
    }
    // MARK: HelperMethod
    func showAlert() {
        self.setupCDAlert(title: "位置情報取得許可されていません", message: "設定アプリの「プライバシー>位置情報サービス」から変更してください", action: "OK", alertType: CDAlertViewType.warning)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.eventId, for: indexPath) as! EventInfoCell
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
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.EventDetailVC) as! EventDetailController
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
        self.indicatorView.stopAnimating()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func fetchEventTimeData(eventArray: [Event]) {
        print(#function)
        if eventArray.isEmpty {
            view.emptyState.show(State.noSearch)
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
                view.emptyState.show(State.noSearch)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - DetailSearchDelegate
extension HomeViewController: DetailSearchDelegate {
    func didTapDetailSearchButton(title: String, circle: String, level: String, placeAddressString: String, money: String, time: String, vc: DetailSearchController) {
        fetchData.searchEventDetailData(title: title,
                                        circle: circle,
                                        level: level,
                                        placeAddressString: placeAddressString,
                                        money: money,
                                        time: time)
        vc.dismiss(animated: true, completion: nil)
    }
    func dismissDetailSearchVC(vc: DetailSearchController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
// MARK: - SearchCalendarDelegate
extension HomeViewController: SearchCalendarDelegate {
    func didTapSearchButton(dateString: String, text: String, vc: SearchCalendarController) {
        fetchData.searchEventDateData(dateString: dateString, text: text)
        vc.dismiss(animated: true, completion: nil)
    }
    func dismissCalendarVC(vc: SearchCalendarController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
// MARK: - EmptyStateDelegate
extension HomeViewController: EmptyStateDelegate {
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        fetchData.fetchEventData(latitude: myLatitude, longitude: myLongitude)
        view.emptyState.hide()
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
                    self.setupCDAlert(title: "通報に失敗しました", message: "", action: "OK", alertType: .warning)
                    print(error)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
    }
}
