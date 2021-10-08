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

class ViewController: UIViewController {
    //Mark: Properties
    private var user:User?
    private var IndicatorView:NVActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var locationManager:CLLocationManager!
    private var fetchData = FetchFirestoreData()
    var (myLatitude,myLongitude) = (Double(),Double())
    private var eventArray = [Event]()
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.tintColor = Utility.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Utility.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var timeButton: UIButton! {
        didSet {
            timeButton.toCorner(num: 15)
        }
    }
    //Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        IndicatorView.startAnimating()
        setupLocationManager()
        setupDelegate()
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
        setupCollectionView()
        setupEmptyState()
        Firestore.deleteEvent()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Utility.Segue.gotoRegister, sender: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    //Mark:setupMethod
    private func setupEmptyState() {
        view.emptyState.delegate = self
        var format = EmptyStateFormat()
        format.buttonColor = Utility.AppColor.OriginalBlue
        format.buttonWidth = 200
        format.titleAttributes = [.foregroundColor:Utility.AppColor.OriginalBlue]
        format.descriptionAttributes = [.strokeWidth:-5,.foregroundColor:UIColor.darkGray]
        format.animation = EmptyStateAnimation.scale(0.3, 2.0)
        format.imageSize = CGSize(width: 200, height: 200)
        view.emptyState.format = format
    }
    
    private func setupDelegate() {
        fetchData.eventDelegate = self
        fetchData.eventSearchDelegate = self
        fetchData.eventTimeDelegate = self
        fetchData.detailDelegate = self
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        let nib = UINib(nibName: Utility.Cell.CollectionViewCell,
                        bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Utility.CellId.eventId)
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
    //Mark:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Utility.Segue.gotoUser {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        }
        if segue.identifier == Utility.Segue.gotoCalendar {
            let vc = segue.destination as! CalendarViewController
            vc.delegate = self
        }
        if segue.identifier == Utility.Segue.gotoDetail {
            let vc = segue.destination as! DetailSearchViewController
            vc.delegate = self
        }
    }
    //Mark:showAlert
    func showAlert() {
        self.setupCDAlert(title: "位置情報取得許可されていません", message: "設定アプリの「プライバシー>位置情報サービス」から変更してください", action: "OK", alertType: CDAlertViewType.warning)
    }
    //Mark IBAction
    @IBAction private func scroll(_ sender: Any) {
        print(#function)
        if eventArray.count != 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated:true)
        }
    }
}
//Mark: UICollectionDelegate
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.eventId, for: indexPath) as! CollectionViewCell
        if eventArray.isEmpty {
            return cell
        } else {
            let event = eventArray[indexPath.row]
            cell.event = event
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        return CGSize(width: width, height: width - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.EventDetailVC) as! EventDetailViewController
        vc.event = eventArray[indexPath.row]
        let teamId = eventArray[indexPath.row].teamId
        Firestore.getTeamData(teamId: teamId) { team in
            vc.team = team
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//Mark: CLLocationMangerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else { return }
        guard let longitude = location?.coordinate.longitude else { return }
        self.myLatitude = latitude
        self.myLongitude = longitude
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
    }
}
//Mark: GetEventSearchDelegate
extension ViewController:GetEventSearchDelegate {
    
    func getEventSearchData(eventArray: [Event]) {
        self.eventArray = eventArray
        print(#function)
        if eventArray.isEmpty {
            view.emptyState.show(State.noSearch)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//Mark: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            self.setupCDAlert(title: "検索エラー", message: "１文字以上入力してください", action: "OK", alertType: CDAlertViewType.error)
            return
        }
        fetchData.searchText(text: searchText)
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
            fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
            searchBar.resignFirstResponder()
        } else {
            fetchData.searchText(text: text)
        }
    }
}
//Mark GetEventTimeDelegate
extension ViewController: GetEventTimeDelegate{
    
    func getEventTimeData(eventArray: [Event]) {
        print(#function)
        if eventArray.isEmpty {
            view.emptyState.show(State.noSearch)
        }
        self.eventArray = eventArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//Mark GetEventDelegate
extension ViewController:GetEventDelegate {
    func getEventData(eventArray: [Event]) {
        print(#function)
        self.eventArray = eventArray
        self.IndicatorView.stopAnimating()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//Mark: GetDetailDataDelegate
extension ViewController:GetDetailDataDelegate {
    func getDetailData(eventArray: [Event]) {
        print(#function)
        self.eventArray = eventArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
//Mark: GetDatailDelegate
extension ViewController: getDetailDelegate {
    
    func getDetailElement(title: String, circle: String, level: String, placeAddressString: String, money: String, time: String) {
        fetchData.detailSearchEventData(title: title, circle: circle, level: level, placeAddressString: placeAddressString, money: money, time: time)
    }
}
//Mark: CalendarDelegate
extension ViewController: CalendarDelegate {
    
    func searchCalendar(dateString: String,text:String) {
        fetchData.searchDateEvent(dateString:dateString,text: text)
    }
}
//Mark EmptyStateDelegate
extension ViewController:EmptyStateDelegate{
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
        view.emptyState.hide()
    }
}




