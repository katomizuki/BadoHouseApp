import UIKit
import MapKit
import CoreLocation
import CDAlertView
// MARK: - Protocol
protocol SearchLocationProtocol: AnyObject {
    func sendLocationData(location: [Double],
                          placeName: String,
                          placeAddress: String,
                          vc: MapViewController)
    func dismissMapVC(vc: MapViewController)
}
final class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    // MARK: - Properties
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTap(_:)))
            mapView.addGestureRecognizer(gesture)
            mapView.isUserInteractionEnabled = true
        }
    }
    var locManager: CLLocationManager!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.updateSaveButton()
            saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = Constants.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Constants.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
        }
    }
    private var (placeName, placeAddress) = (String(), String())
    private var (placeLatitude, placeLongitude) = (Double(), Double())
    weak var delegate: SearchLocationProtocol?
    private var defaultRegion: MKCoordinateRegion {
        let coordinate = CLLocationCoordinate2D(
            latitude: 35.680,
            longitude: 139.767
        )
        let span = MKCoordinateSpan(
            latitudeDelta: 0.001,
            longitudeDelta: 0.001
        )
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(defaultRegion, animated: false)
        searchBar.delegate = self
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    // MARK: - SelectorMethod
    @objc private func mapTap(_ gesture: UITapGestureRecognizer) {
        let coordinate = mapView.convert(gesture.location(in: mapView), toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativeArea = placemark.administrativeArea, // 都道府県
                let locality = placemark.locality, // 市区町村
                let thoroughfare = placemark.thoroughfare, // 地名(丁目)
                let subThoroughfare = placemark.subThoroughfare, // 番地
                let location = placemark.location // 緯度経度情報
            else {
                return
            }
            self.placeAddress = administrativeArea + locality + thoroughfare + subThoroughfare
            let targetLocation = location.coordinate
            let latitude = targetLocation.latitude
            let longitude = targetLocation.longitude
            self.placeLatitude = latitude
            self.placeLongitude = longitude
        }
    }
    @objc private func back() {
        self.delegate?.dismissMapVC(vc: self)
    }
    // MARK: - IBAtion
    @IBAction private func saveButton(_ sender: Any) {
        self.delegate?.sendLocationData(location: [placeLatitude, placeLongitude],
                                        placeName: placeName,
                                        placeAddress: placeAddress,
                                        vc: self)
    }
}
// MARK: - SearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let search = searchBar.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(search) { placemark, error in
                if let error = error {
                    print("Location", error)
                    self.setupCDAlert(title: "検索エラー",
                                      message: "開催場所の正式名称を入力してください",
                                      action: "OK",
                                      alertType: .error)
                    return
                }
                if let safePlacemark = placemark {
                    if let firstPlacemark = safePlacemark.first {
                        guard let preference = firstPlacemark.administrativeArea else { return }
                        guard let locality = firstPlacemark.locality else { return }
                        let thorough = firstPlacemark.thoroughfare ?? ""
                        let subThorough = firstPlacemark.subThoroughfare ?? ""
                        self.placeAddress = preference + locality + thorough + subThorough
                        if let location = firstPlacemark.location {
                            let targetCoordinate = location.coordinate
                            let targetLatitude = targetCoordinate.latitude
                            let targetLongitude = targetCoordinate.longitude
                            self.placeLatitude = targetLatitude
                            self.placeLongitude = targetLongitude
                            self.placeName = search
                            let pin = MKPointAnnotation()
                            pin.coordinate = targetCoordinate
                            pin.title = search
                            self.mapView.addAnnotation(pin)
                            self.mapView.region = MKCoordinateRegion(center: targetCoordinate,
                                                                     latitudinalMeters: 500.0,
                                                                     longitudinalMeters: 500.0)
                        }
                    }
                }
            }
        }
    }
}
