//
//  PracticeDetailController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/15.
//

import UIKit
import CDAlertView
import Charts
import CoreLocation
import MapKit
protocol PracticeDetailFlow {
    
}
final class PracticeDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var leaderImageView: UIImageView!
    @IBOutlet private weak var mapView: MKMapView!
    private var defaultRegion: MKCoordinateRegion {
        let x =  0.0
        let y = 0.0
        let coordinate = CLLocationCoordinate2D(
            latitude: x,
            longitude: y
        )
        let span = MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    var coordinator: PracticeDetailFlow?
    private var chatId: String?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

