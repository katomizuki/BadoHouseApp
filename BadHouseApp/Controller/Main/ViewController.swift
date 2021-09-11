

import UIKit
import Firebase
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import CoreLocation
import MapKit



class ViewController: UIViewController,GetEventDelegate{
    
    //Mark: Properties
    private var user:User?
    private var IndicatorView:NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var locationManager:CLLocationManager!
    private var fetchData = FetchFirestoreData()
    var myLatitude = Double()
    var myLongitude = Double()
    private var eventArray = [Event]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData.eventDelegate = self
        fetchData.eventSearchDelegate = self
        searchBar.delegate = self
        fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
        setupLocationManager()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        //Mark:NVActivityIndicatorView
        navigationController?.isNavigationBarHidden = false
        let frame = CGRect(x: view.frame.width / 2,
                           y: view.frame.height / 2,
                           width: 100,
                           height: 100)
        
        IndicatorView = NVActivityIndicatorView(frame: frame,
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
        
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Utility.CellId.eventId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Utility.Segue.gotoRegister, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Mark:NVActivityIndicatorView
        navigationController?.isNavigationBarHidden = false
    }
    
    //Mark: IBAction
    @IBAction func gotoUser(_ sender: Any) {
        IndicatorView.startAnimating()
        let uid = Auth.getUserId()
        Firestore.getUserData(uid: uid) { user in
            self.IndicatorView.stopAnimating()
            guard let user = user else { return }
            self.user = user
            self.performSegue(withIdentifier:  Utility.Segue.gotoUser, sender: nil)
        }
    }
    
    //Mark:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Utility.Segue.gotoUser {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        }
    }
    
    //Mark:currentLocationgetMethod
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
    
    
    //Mark:showAlert
    func showAlert() {
        let alertTitle = "位置情報取得許可されていません"
        let alertMessage = "設定アプリの「プライバシー>位置情報サービス」から変更してください"
        let alert:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        let defaultAction:UIAlertAction = UIAlertAction (title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark:DelegateMethod
    func getEventData(eventArray: [Event]) {
        print(#function)
        self.eventArray = eventArray
        collectionView.reloadData()
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.eventId, for: indexPath) as! CollectionViewCell
        if eventArray.isEmpty {
            return cell
        } else {
            cell.placeLabel.text = "at " + self.eventArray[indexPath.row].eventPlace
            var text = self.eventArray[indexPath.row].eventStartTime
            let from = text.index(text.startIndex, offsetBy: 5)
            let to = text.index(text.startIndex, offsetBy: 15)
            text = String(text[from...to])
            let index = text.index(text.startIndex, offsetBy: 5)
            text.insert("日", at: index)
            if text.prefix(1) == "0" {
                let index = text.index(text.startIndex, offsetBy: 0)
                text.remove(at: index)
            }
            text = text.replacingOccurrences(of: "/", with: "月")
            text = text.replacingOccurrences(of: ":", with: "時")
            
            cell.timeLabel.text = text + "分 スタート"
            cell.titleLabel.text = self.eventArray[indexPath.row].eventTitle
            cell.teamLabel.text = self.eventArray[indexPath.row].teamName
            let urlString = self.eventArray[indexPath.row].eventUrl
            let url = URL(string: urlString)
            let teamurlString = self.eventArray[indexPath.row].teamImageUrl
            if teamurlString != "" {
                let url = URL(string: teamurlString)
                cell.userImageView.sd_setImage(with: url, completed: nil)
            }
            cell.teamImage.sd_setImage(with: url, completed: nil)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        return CGSize(width: width, height: width - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.EventDetailVC) as! EventDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

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

extension ViewController:GetEventSearchDelegate {
    
    func getEventSearchData(eventArray: [Event]) {
        print(eventArray)
        self.eventArray = eventArray
        collectionView.reloadData()
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        fetchData.searchText(text: searchText)
        searchBar.resignFirstResponder()
        print("🎨")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        if searchBar.text == "" {
            print("🍏")
            fetchData.fetchEventData(latitude: self.myLatitude, longitude: self.myLongitude)
            searchBar.resignFirstResponder()
        }
    }
}
