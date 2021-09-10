

import UIKit
import Firebase
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import CoreLocation
import MapKit



class ViewController: UIViewController{
    
    
    
    //Mark: Properties
    private var user:User?
    private var IndicatorView:NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var locationManager:CLLocationManager!
    private var fetchData = FetchFirestoreData()
    
    //Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData.fetchEventData()
        setupLocationManager()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        //Mark:NVActivityIndicatorView
        navigationController?.isNavigationBarHidden = false
        IndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width / 2,
                                                              y: view.frame.height / 2,
                                                              width: 100,
                                                              height: 100),
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Utility.Segue.gotoUser {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        }
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        print("🍎")
        if status == .authorizedWhenInUse {
            print("🍏")
            
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func showAlert() {
        let alertTitle = "位置情報取得許可されていません"
        let alertMessage = "設定アプリの「プライバシー>位置情報サービス」から変更してください"
        let alert:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        let defaultAction:UIAlertAction = UIAlertAction (title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.eventId, for: indexPath) as! CollectionViewCell

        
               return cell
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
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        print(latitude as Any)
        print(longitude as Any)
        }

}

