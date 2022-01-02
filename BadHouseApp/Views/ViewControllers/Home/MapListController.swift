//
//  MapListController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
import MapKit
import CoreLocation
protocol MapListFlow:AnyObject {
    
}
final class MapListController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    var coordinator:MapListFlow?
    var viewModel:MapListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialCoordinate = CLLocationCoordinate2DMake(viewModel.currnetLatitude,
                                                           viewModel.currentLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: initialCoordinate, span: span)
        mapView.setRegion(region, animated:true)
    }
    
    func addAnnotation(_ latitude: CLLocationDegrees,_ longitude: CLLocationDegrees, _title:String,_ subtitle:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
}
