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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// MARK: - SearchBarDelegate

