import UIKit
import MapKit
import CoreLocation

final class MapListController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    var coordinator: MapListFlow?
    private let viewModel: MapListViewModel
    
    init(viewModel: MapListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        let initialCoordinate = CLLocationCoordinate2DMake(viewModel.currnetLatitude,
                                                           viewModel.currentLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: initialCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        viewModel.practices.forEach {
            addAnnotation($0.latitude, $0.longitude, $0.title, $0.placeName)
        }
        
    }
    
    func addAnnotation(_ latitude: CLLocationDegrees,
                       _ longitude: CLLocationDegrees,
                       _ title: String,
                       _ subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
}

extension MapListController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let practice = viewModel.practices.filter {
                $0.title == annotation.title && $0.placeName == annotation.subtitle
            }
            coordinator?.halfModal(practice[0], self, myData: viewModel.myData)
        }
    }
}
