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
import RxSwift
protocol PracticeDetailFlow {
    func toCircleDetail(myData:User,circle:Circle)
    func toUserDetail(myData: User, user: User)
    func toChat()
}
final class PracticeDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet  weak var chatButton: UIButton!
    @IBOutlet private weak var practiceImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet { userImageView.changeCorner(num: 30) }
    }
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet { circleImageView.changeCorner(num: 30) }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var circleNameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var finishLabel: UILabel!
    @IBOutlet private weak var deadLineLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet weak var userDetailButton: UIButton!
    @IBOutlet weak var circleDetailButton: UIButton!
    @IBOutlet private weak var courtLabel: UILabel!
    @IBOutlet private weak var gatherLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    private var defaultRegion: MKCoordinateRegion {
        let x =  viewModel.practice.latitude
        let y = viewModel.practice.longitude
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
    var viewModel: PracticeDetailViewModel!
    private lazy var rightButton = UIBarButtonItem(title: "参加申請", style: .done, target: self, action: #selector(didTapRightButton))
    private let disposeBag = DisposeBag()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBinding()
        setupMapView()
    }
    private func setupMapView() {
        mapView.setRegion(defaultRegion, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(viewModel.practice.latitude, viewModel.practice.longitude)
        mapView.addAnnotation(pin)
    }
    
    @IBAction private func didTapChatButton(_ sender: Any) {
    }
    @IBAction private func didTapCircleDetailButton(_ sender: Any) {
        coordinator?.toCircleDetail(myData: viewModel.myData!, circle: viewModel.circle!)
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightButton
    }
    private func setupBinding() {
        priceLabel.text = viewModel.practice.price
        practiceImageView.sd_setImage(with: viewModel.practice.mainUrl)
        textView.text = viewModel.practice.explain
        titleLabel.text = viewModel.practice.title
        courtLabel.text = String(viewModel.practice.court) + "面"
        gatherLabel.text = String(viewModel.practice.gather) + "人"
        startLabel.text = viewModel.practice.detailStartTimeString
        finishLabel.text = viewModel.practice.detailEndTimeString
        deadLineLabel.text = viewModel.practice.detailDeadLineTimeString
        
        
        viewModel.outputs.userRelay.subscribe(onNext: {[weak self] user in
            self?.userImageView.sd_setImage(with: user.profileImageUrl)
            self?.userNameLabel.text = user.name
        }).disposed(by: disposeBag)
        
        viewModel.outputs.circleRelay.subscribe(onNext: { [weak self] circle in
            self?.circleImageView.sd_setImage(with: circle.iconUrl)
            self?.circleNameLabel.text = circle.name
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isButtonHidden.subscribe { [weak self] _ in
            self?.navigationItem.rightBarButtonItem = nil
            self?.chatButton.isHidden = true
        }.disposed(by: disposeBag)
        
        
    }
    
    @objc private func didTapRightButton() {
        
    }
    @IBAction private func didTapUserButton(_ sender: Any) {
        coordinator?.toUserDetail(myData: viewModel.myData!, user: viewModel.user!)
    }
}

