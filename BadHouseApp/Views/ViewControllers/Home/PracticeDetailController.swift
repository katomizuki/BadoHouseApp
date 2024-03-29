import UIKit
import Charts
import CoreLocation
import MapKit
import RxSwift

final class PracticeDetailController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var chatButton: UIButton!
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
    @IBOutlet private weak var userDetailButton: UIButton!
    @IBOutlet private weak var circleDetailButton: UIButton!
    @IBOutlet private weak var courtLabel: UILabel!
    @IBOutlet private weak var gatherLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    private let viewModel: PracticeDetailViewModel
    private let disposeBag = DisposeBag()
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
    private lazy var rightButton = UIBarButtonItem(title: R.buttonTitle.takePartIn, style: .done, target: self, action: #selector(didTapRightButton))
   
    
    var coordinator: PracticeDetailFlow?
    
    init(viewModel: PracticeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupMapView() {
        mapView.setRegion(defaultRegion, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(viewModel.practice.latitude, viewModel.practice.longitude)
        mapView.addAnnotation(pin)
    }
    
    @IBAction private func didTapChatButton(_ sender: Any) {
        coordinator?.toChat(myData: viewModel.myData, user: viewModel.user!)
    }
    
    @IBAction private func didTapCircleDetailButton(_ sender: Any) {
        coordinator?.toCircleDetail(myData: viewModel.myData, circle: viewModel.circle!)
    }
    
    func setupUI() {
        setupMapView()
        setupViewData()
    }
    
    private func setupViewData() {
        priceLabel.text = viewModel.practice.price
        practiceImageView.sd_setImage(with: viewModel.practice.mainUrl)
        textView.text = viewModel.practice.explain
        titleLabel.text = viewModel.practice.title
        courtLabel.text = String(viewModel.practice.court) + "面"
        gatherLabel.text = String(viewModel.practice.gather) + "人"
        startLabel.text = viewModel.practice.detailStartTimeString
        finishLabel.text = viewModel.practice.detailEndTimeString
        deadLineLabel.text = viewModel.practice.detailDeadLineTimeString
        levelLabel.text = "\(viewModel.practice.minLevel)〜\(viewModel.practice.maxLevel)"
        circleDetailButton.isHidden = viewModel.isModal
        userDetailButton.isHidden = viewModel.isModal
        navigationItem.rightBarButtonItem = viewModel.practice.isPreJoined ? nil : rightButton
    }

    private func setupBinding() {
        
        viewModel.outputs.userRelay.subscribe(onNext: {[weak self] user in
            guard let self = self else { return }
            self.userImageView.sd_setImage(with: user.profileImageUrl)
            self.userNameLabel.text = user.name
        }).disposed(by: disposeBag)
        
        viewModel.outputs.circleRelay.subscribe(onNext: { [weak self] circle in
            guard let self = self else { return }
            self.circleImageView.sd_setImage(with: circle.iconUrl)
            self.circleNameLabel.text = circle.name
        }).disposed(by: disposeBag)
        
        viewModel.outputs.isButtonHidden.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem = nil
            self.chatButton.isHidden = true
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe {[weak self] _  in
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.joinMessage,
                             message: "",
                             action: R.alertMessage.ok)
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    @objc private func didTapRightButton() {
        viewModel.inputs.onTapTakePartInButton()
    }
    
    @IBAction private func didTapUserButton(_ sender: Any) {
        coordinator?.toUserDetail(myData: viewModel.myData, user: viewModel.user!)
    }
}
