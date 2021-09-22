import UIKit
import MapKit
import CoreLocation

protocol SearchLocationProtocol {
    func sendLocationData(location:[Double],placeName:String,placeAddress:String)
}

class MapViewController: UIViewController{

    //Mark:Properties
    @IBOutlet weak var mapView: MKMapView!
    var locManager:CLLocationManager!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    private var placeName = String()
    private var placeAddress = String()
    private var placeLatitude = Double()
    private var placeLongitude = Double()
    var delegate:SearchLocationProtocol?
    private var defaultRegion: MKCoordinateRegion {
            let coordinate = CLLocationCoordinate2D( 
                latitude: 35.680,
                longitude: 139.767
            )
            let span = MKCoordinateSpan (
                latitudeDelta: 0.001,
                longitudeDelta: 0.001
            )
            return MKCoordinateRegion(center: coordinate, span: span)
        }
    
    @IBOutlet weak var searchButton: UIButton!
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.backgroundColor = Utility.AppColor.OriginalBlue
        saveButton.setTitleColor(.white, for: UIControl.State.normal)
        saveButton.layer.cornerRadius = 15
        saveButton.layer.masksToBounds = true
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTap(_:)))
             mapView.addGestureRecognizer(gesture)
             mapView.setRegion(defaultRegion, animated: false)
        textField.delegate = self
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    //Mark:selector
    @objc private func mapTap(_ gesture:UITapGestureRecognizer) {
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
    
    
    
    
    //Mark:IBAction
    @IBAction func saveButton(_ sender: Any) {
        self.delegate?.sendLocationData(location: [placeLatitude,placeLongitude], placeName: placeName,placeAddress:placeAddress)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func search(_ sender: Any) {
        if let search = textField.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(search) { placemark, error in
                if let error = error {
                    print("Location",error)
                    self.showAlert(title: "検索エラー", message: "開催場所の正式名称を入力してください", actionTitle: "OK")
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
                            self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            }
        }
    }
    
}

extension MapViewController:CLLocationManagerDelegate,UIGestureRecognizerDelegate {
    
}

extension MapViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let search = textField.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(search) { placemark, error in
                if let error = error {
                    print("Location",error)
                    self.showAlert(title: "検索エラー", message: "開催場所の正式名称を入力してください", actionTitle: "OK")
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
                            self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            }
        }
        return true
    }
    
}

