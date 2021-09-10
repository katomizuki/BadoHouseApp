

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    var locManager:CLLocationManager!
    @IBOutlet weak var saveButton: UIButton!
    
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

    }
    
    
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
                     let postalCode = placemark.postalCode, // 郵便番号
                     let location = placemark.location // 緯度経度情報
                     else {
                         return
                 }
            print(placemark)
            print(administrativeArea)
            print(locality)
            print(thoroughfare)
            print(thoroughfare)
            print(subThoroughfare)
            print(location)
        }
    }
    private var defaultRegion: MKCoordinateRegion {
            let coordinate = CLLocationCoordinate2D( // 大阪駅
                latitude: 34.7024854,
                longitude: 135.4937619
            )
            let span = MKCoordinateSpan (
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
            return MKCoordinateRegion(center: coordinate, span: span)
        }

}

extension MapViewController:CLLocationManagerDelegate,UIGestureRecognizerDelegate {
    
}
