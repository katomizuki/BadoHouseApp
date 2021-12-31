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
    func toCircleDetail()
    func toUserDetail()
    func toChat()
}
final class PracticeDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var practiceImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet { userImageView.changeCorner(num: 30) }
    }
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet { circleImageView.changeCorner(num: 30) }
    }
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
    var coordinator: PracticeDetailFlow?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    @IBAction private func didTapChatButton(_ sender: Any) {
    }
    @IBAction private func didTapCircleDetailButton(_ sender: Any) {
        print(#function)
        coordinator?.toCircleDetail()
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "参加申請", style: .done, target: self, action: #selector(didTapRightButton))
    }
    @objc private func didTapRightButton() {
        
    }
    @IBAction private func didTapUserButton(_ sender: Any) {
//        coordinator?.toUserDetail()
        let controller = MainUserDetailController.init(nibName: R.nib.mainUserDetailController.name, bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}

