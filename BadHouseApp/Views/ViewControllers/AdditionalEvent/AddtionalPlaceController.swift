import UIKit
import CoreLocation
import MapKit
protocol AddtionalPlaceFlow {
}
protocol AddtionalPlaceControllerDelegate: AnyObject {
    func AddtionalPlaceController(vc:AddtionalPlaceController,
                                  placeName: String,
                                  addressName: String,
                                  latitude: Double,
                                  longitude: Double)
}
class AddtionalPlaceController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    var coordinator: AddtionalPlaceFlow?
    weak var delegate: AddtionalPlaceControllerDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTap(_:)))
            mapView.addGestureRecognizer(gesture)
            mapView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    private var (placeLatitude, placeLongitude) = (Double(), Double())
    private var (placeName, placeAddress) = (String(), String())
    var locManager: CLLocationManager!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(defaultRegion, animated: false)
        searchBar.delegate = self
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                    target: self,
                                                    action: #selector(didTapLeftButton))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapRightButton))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            searchBar.becomeFirstResponder()
    }
    @objc private func didTapLeftButton() {
        dismiss(animated: true)
    }
    @objc private func didTapRightButton() {
        self.delegate?.AddtionalPlaceController(vc: self,
                                                placeName: placeName,
                                                addressName: placeAddress,
                                                latitude: placeLatitude,
                                                longitude: placeLongitude)
    }
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
}

extension AddtionalPlaceController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let search = searchBar.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(search) { placemark, error in
                if  error != nil {
                    self.showCDAlert(title: "検索エラー",
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
