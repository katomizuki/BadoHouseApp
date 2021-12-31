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
    func toDetailSearch(_ vc: UIViewController)
    func toPracticeDetail()
    func toAuthentication(_ vc: UIViewController)
}
final class MainViewController: UIViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager!
    var (myLatitude, myLongitude) = (Double(), Double())
    private let disposeBag = DisposeBag()
    var coordinator: MainFlow?
    private let viewModel = HomeViewModel(practiceAPI: PracticeServie())
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
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
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
        
        viewModel.outputs.practiceRelay.bind(to: collectionView.rx.items(cellIdentifier: EventInfoCell.id, cellType: EventInfoCell.self)) { _,item,cell in
            cell.delegate = self
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            self?.coordinator?.toPracticeDetail()
        }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 50)
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
