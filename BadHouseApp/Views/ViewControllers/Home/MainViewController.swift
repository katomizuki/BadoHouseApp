import UIKit
import Firebase
import RxCocoa
import RxSwift
import CoreLocation
import MapKit
import UserNotifications
import CDAlertView
protocol MainFlow: AnyObject {
    func toMap()
    func toMakeEvent()
    func toDetailSearch(_ vc:UIViewController)
    func toPracticeDetail()
    func toAuthentication(_ vc:UIViewController)
}
final class MainViewController: UIViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    var (myLatitude, myLongitude) = (Double(), Double())
    private let disposeBag = DisposeBag()
    var coordinator: MainFlow?
    private let viewModel = HomeViewModel()
    @IBOutlet private weak var collectionView: UICollectionView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad()
        setupLocationManager()
        setupCollectionView()
        setupBinding()
        setupNavBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
    }
    private func setupNavBarButton() {
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "location.north.circle.fill"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapMapButton))
        let detailSearchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapDetailSearchButton))
        let makeEventButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(didTapMakeEventButton))
        navigationItem.rightBarButtonItems = [detailSearchButton, mapButton]
        navigationItem.leftBarButtonItem = makeEventButton
        if #available(iOS 15.0, *) {
            navigationItem.leftBarButtonItem?.tintColor = .tintColor
        }
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = .tintColor
        }
        navigationController?.isNavigationBarHidden = false
        navigationItem.backButtonDisplayMode = .minimal
    }
    @objc private func didTapMapButton() {
        coordinator?.toMap()
    }
    @objc private func didTapDetailSearchButton() {
        coordinator?.toDetailSearch(self)
    }
    @objc private func didTapMakeEventButton() {
        print(#function)
        coordinator?.toMakeEvent()
    }
    private func setupBinding() {
        viewModel.outputs.isAuth.bind { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.toAuthentication(self)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isNetWorkError.bind { [weak self] _ in
            guard let self = self else { return }
            self.showCDAlert(title: "ネットワークがつながっておりません", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
    }
    
   
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(EventInfoCell.nib(), forCellWithReuseIdentifier: EventInfoCell.id)
        collectionView.showsVerticalScrollIndicator = false
    }
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
}
// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventInfoCell.id, for: indexPath) as? EventInfoCell else { fatalError() }
        cell.delegate = self
        return cell
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 50)
    }
}
// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.toPracticeDetail()
    }
}
// MARK: - CLLOcationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else { return }
        guard let longitude = location?.coordinate.longitude else { return }
        myLatitude = latitude
        myLongitude = longitude
    }
}
extension MainViewController: EventInfoCellDelegate {
    func didTapBlockButton(_ cell: EventInfoCell) {
        present(AlertProvider.postAlertVC(), animated: true)
    }
}
