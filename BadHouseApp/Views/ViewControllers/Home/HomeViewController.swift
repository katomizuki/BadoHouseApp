import UIKit
import RxCocoa
import RxSwift
import CoreLocation
import MapKit
import Domain

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!

    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return indicator
    }()
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    private var locationManager: CLLocationManager!
    private var (myLatitude, myLongitude) = (Double(), Double())
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        return refreshControl
    }()
    
    var coordinator: HomeFlow?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.didLoadInput.onNext(())
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.inputs.willDisAppear.onNext(())
    }
    
    private func setupUI() {
        setupIndicatorView()
        setupRefreshControl()
        setupNavBarButton()
        setupLocationManager()
        setupCollectionView()
    }
    
    private func setupIndicatorView() {
        indicatorView.center = self.view.center
        view.addSubview(indicatorView)
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
    }
    
    private func setupNavBarButton() {
        let mapButton = UIBarButtonItem(image: UIImage(systemName: R.SFSymbols.location),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapMapButton))
        let detailSearchButton = UIBarButtonItem(image: UIImage(systemName: R.SFSymbols.magnifyingglass),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapDetailSearchButton))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefreshButton))
        let makeEventButton = UIBarButtonItem(image: UIImage(systemName: R.SFSymbols.square),
                                              style: .plain,
                                              target: self,
                                              action: #selector(didTapMakeEventButton))
        navigationItem.rightBarButtonItems = [refreshButton, detailSearchButton, mapButton]
        navigationItem.leftBarButtonItem = makeEventButton
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        navigationController?.isNavigationBarHidden = false
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    @objc private func didTapMapButton() {
        coordinator?.toMap(practices: viewModel.practiceRelay.value,
                           lat: myLatitude,
                           lon: myLongitude,
                           myData: viewModel.myData)
    }
    
    @objc private func didTapDetailSearchButton() {
        coordinator?.toDetailSearch(self, practices: viewModel.practiceRelay.value)
    }
    
    @objc private func didTapMakeEventButton() {
        coordinator?.toMakeEvent()
    }
    
    @objc private func refreshCollectionView() {
        viewModel.inputs.refresh()
    }
    
    private func setupBinding() {
        
        viewModel.outputs.isAuth.bind { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.toAuthentication(self)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.isNetWorkError.bind { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.notNet,
                             message: "",
                             action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.practiceRelay.bind(to: collectionView.rx.items(cellIdentifier: EventInfoCell.id, cellType: EventInfoCell.self)) { _, item, cell in
            cell.delegate = self
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.coordinator?.toPracticeDetail(self.viewModel.practiceRelay.value[indexPath.row], myData: self.viewModel.myData)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.reload.subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.outputs
            .isIndicatorAnimating
            .subscribe(onNext: { [weak self] isAnimating in
            if isAnimating {
                self?.indicatorView.startAnimating()
            } else {
                self?.indicatorView.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        viewModel.outputs
            .isRefreshAnimating
            .subscribe(onNext: { [weak self] isAnimating in
            if isAnimating {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width: Int = Int(collectionView.frame.width - 30)
        let height: Int = Int(collectionView.frame.width - 50)
        layout.itemSize = CGSize(width: width, height: height)
        collectionView.collectionViewLayout = layout
        collectionView.register(EventInfoCell.nib(), forCellWithReuseIdentifier: EventInfoCell.id)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        case .notDetermined, .denied, .restricted:
            print("")
        default:break
        }
    }
    
    @objc private func didTapRefreshButton() {
        viewModel.inputs.refresh()
    }
}
// MARK: - CLLOcationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else { return }
        guard let longitude = location?.coordinate.longitude else { return }
        myLatitude = latitude
        myLongitude = longitude
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        case .notDetermined, .denied, .restricted:
            print("")
        default:break
        }
    }
}

extension HomeViewController: EventInfoCellDelegate {

    func didTapBlockButton(_ cell: EventInfoCell,
                           practice: Domain.Practice) {
        let alertVC = AlertProvider.postAlertVC(practice) { error in
            if error != nil {
                self.showAlert(title: R.alertMessage.netError,
                                 message: "",
                                 action: R.alertMessage.ok)
            }
            self.showAlert(title: R.alertMessage.block,
                             message: "",
                             action: R.alertMessage.ok)
        }
        present(alertVC, animated: true)
    }
}

extension HomeViewController: PracticeSearchControllerDelegate {

    func eventSearchControllerDismiss(practices: [Domain.Practice],
                                      vc: PracticeSearchController) {
        vc.dismiss(animated: true)
        viewModel.inputs.search(practices)
    }
}
