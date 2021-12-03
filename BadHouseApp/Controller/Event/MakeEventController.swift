import UIKit
import RxSwift
import RxCocoa
import Firebase

final class MakeEventController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var gatherCountLabel: UILabel!
    @IBOutlet private weak var courtCountLabel: UILabel!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var startPicker: UIDatePicker!
    @IBOutlet private weak var finishPicker: UIDatePicker!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var makeEventButton: UIButton! {
        didSet {
            makeEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var detaiTextView: UITextView!
    @IBOutlet private weak var circleSegment: UISegmentedControl! {
        didSet {
            circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
        }
    }
    @IBOutlet private weak var noImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            scrollView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet private weak var notMoneyLabel: UILabel!
    @IBOutlet private weak var notTimeLabel: UILabel!
    @IBOutlet private weak var notTitleLabel: UILabel!
    @IBOutlet private weak var notPlaceLabel: UILabel!
    private let moneyArray = Constants.Data.moneyArray
    private let moneyPickerView = UIPickerView()
    private let fetchData = FetchFirestoreData()
    private let eventBinding = MakeEventViewModel()
    private let disposeBag = DisposeBag()
    private var selectedTeam: TeamModel?
    private var (teamPlace, teamTime) = (String(), String())
    private var (eventTitle,
                 eventStartTime,
                 eventLastTime,
                 eventLevel,
                 eventMoney,
                 courtCount,
                 gatherCount,
                 detailText,
                 placeAddress) = (String(), String(), String(), String(), String(), String(), String(), String(), String())
    private var kindCircle = BadmintonCircle(rawValue: 0)?.name
    private var (placeLatitude, placeLongitude) = (Double(), Double())
    private var dic = [String: Any]()
    private var team: TeamModel?
    private var pickerArray = [TeamModel]()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupBinding()
        setupOwnTeamData()
        setupToolBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    // MARK: - SetupMethod
    private func setupDelegate() {
        moneyPickerView.delegate = self
        moneyPickerView.dataSource = self
        titleTextField.delegate = self
        fetchData.myDataDelegate = self
    }
    private func setupToolBar() {
        moneyTextField.inputView = moneyPickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0,
                               y: 0,
                               width: self.view.frame.width,
                               height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleButton, doneButtonItem], animated: true)
        moneyTextField.inputAccessoryView = toolBar
    }
    
    private func setupBinding() {
        datePicker.rx.value.changed
            .asObservable()
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                let string = self.formatterUtil(date: date)
                self.eventBinding.dateTextInput.onNext(string)
                self.teamTime = string
            })
            .disposed(by: disposeBag)
        finishPicker.rx.value.changed
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                let string = self.formatterUtil(date: data)
                self.eventLastTime = string
                self.eventBinding.finishTextInput.onNext(string)
            })
            .disposed(by: disposeBag)
        startPicker.rx.value.changed
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                let string = self.formatterUtil(date: data)
                self.eventStartTime = string
                self.eventBinding.startTextInput.onNext(string)
            })
            .disposed(by: disposeBag)
        moneyTextField.rx.text.asDriver()
            .drive { [weak self] text in
                guard let self = self else { return }
                self.moneyTextField.layer.borderColor = text?.count == 0 ? UIColor.lightGray.cgColor : Constants.AppColor.OriginalBlue.cgColor
                self.notMoneyLabel.isHidden = text?.count != 0 ? true : false
                self.moneyTextField.layer.borderWidth = text?.count == 0 ? 2 : 3
                let text = text ?? ""
                self.eventMoney = text
                self.eventBinding.moneyTextInput.onNext(text)
            }
            .disposed(by: disposeBag)
        titleTextField.rx.text.asDriver()
            .drive { [weak self] text in
                guard let self = self else { return }
                self.titleTextField.layer.borderColor = text?.count == 0 ? UIColor.lightGray.cgColor : Constants.AppColor.OriginalBlue.cgColor
                self.notTitleLabel.isHidden = text?.count != 0 ? true : false
                self.titleTextField.layer.borderWidth = text?.count == 0 ? 2 : 3
                let title = text ?? ""
                self.eventTitle = title
                self.eventBinding.titleTextInput.onNext(title)
            }
            .disposed(by: disposeBag)
        eventBinding.valideMakeDriver
            .drive { [weak self] validAll in
                guard let self = self else { return }
                self.makeEventButton.isEnabled = validAll
                self.makeEventButton.backgroundColor = validAll ?
                Constants.AppColor.OriginalBlue:.darkGray
            }
            .disposed(by: disposeBag)
    }
    private func setupOwnTeamData() {
        let uid = AuthService.getUserId()
        UserService.getOwnTeam(uid: uid) { [weak self] teamIds in
            guard let self = self else { return }
            self.fetchData.fetchMyTeamData(idArray: teamIds)
        }
    }
    // MARK: - SelectorMethod
    @objc private func segmentTap(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        kindCircle = BadmintonCircle(rawValue: index)?.name
    }
    @objc private func handleTap() {
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        detaiTextView.resignFirstResponder()
        notTitleLabel.isHidden = titleTextField.text?.isEmpty == true ? false : true
        notMoneyLabel.isHidden = moneyTextField.text?.isEmpty == true ? false : true
        notPlaceLabel.isHidden = placeTextField.text?.isEmpty == true ? false : true
        if teamTime.isEmpty || eventStartTime.isEmpty || eventLastTime.isEmpty {
            notTimeLabel.isHidden = false
        } else {
            notTimeLabel.isHidden = true
        }
    }
    @objc private func donePicker() {
        moneyTextField.endEditing(true)
    }
    @objc private func createEvent() {
        print(#function)
        var teamImageUrl = String()
        guard let teamId = selectedTeam?.teamId else { return }
        TeamService.getTeamData(teamId: teamId) { [weak self] teamData in
            guard let self = self else { return }
            self.team = teamData
            if let url = self.team?.teamImageUrl {
                teamImageUrl = url
            }
        }
        guard let teamName = selectedTeam?.teamName else { return }
        let max = "10"
        let min = "0"
        eventLevel = min + "~" + max
        courtCount = courtCountLabel.text ?? "1"
        gatherCount = gatherCountLabel.text ?? "1"
        detailText = detaiTextView.text ?? ""
        let userId = AuthService.getUserId()
        let eventId = Ref.EventRef.document().documentID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let dic = ["eventId": eventId,
                       "time": self.teamTime,
                       "place": self.teamPlace,
                       "teamId": teamId,
                       "teamName": teamName,
                       "eventStartTime": self.eventStartTime,
                       "eventLastTime": self.eventLastTime,
                       "eventLavel": self.eventLevel,
                       "eventMoney": self.eventMoney,
                       "detailText": self.detailText,
                       "kindCircle": self.kindCircle,
                       "courtCount": self.courtCount,
                       "gatherCount": self.gatherCount,
                       "eventTitle": self.eventTitle,
                       "latitude": self.placeLatitude,
                       "longitude": self.placeLongitude,
                       "teamImageUrl": teamImageUrl,
                       "placeAddress": self.placeAddress,
                       "userId": userId] as [String: Any]
            guard let eventImage = self.noImageView.image else { return }
        }
    }
    // MARK: IBAction
    @IBAction private func plusCourt(_ sender: UIStepper) {
        let num = String(Int(sender.value) + 1)
        courtCountLabel.text = num
    }
    @IBAction private func plusGather(_ sender: UIStepper) {
        let num = String(Int(sender.value))
        gatherCountLabel.text = num
    }
    @IBAction private func plusImage(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
    }
    @IBAction private func gotoMap(_ sender: Any) {
        print(#function)
        performSegue(withIdentifier: Segue.gotoMap.rawValue, sender: nil)
    }
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.gotoMap.rawValue {
            let nextVC = segue.destination as! MapViewController
            nextVC.delegate = self
        }
    }
}
// MARK: - PickerViewDatasource
extension MakeEventController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return moneyArray.count
    }
}
// MARK: - PickerViewDelegate
extension MakeEventController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return moneyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == moneyPickerView {
            moneyTextField.text = moneyArray[row]
        }
    }
}

// MARK: - UInavigationDelegate
extension MakeEventController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            noImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - getmyTeamDelegate
//extension MakeEventController: FetchMyDataDelegate {
//    func fetchMyTeamData(teamArray: [TeamModel]) {
//        pickerArray = teamArray
//        if teamArray.isEmpty {
//            warningLabel.isHidden = false
//        }
//        if pickerArray.count == 1 {
//            self.selectedTeam = pickerArray[0]
//        }
////        teamPickerView.reloadAllComponents()
//    }
//}
// MARK: - textFieldDelegate
extension MakeEventController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
// MARK: - SearchLocationProtocol
extension MakeEventController: SearchLocationProtocol {
    func sendLocationData(location: [Double], placeName: String, placeAddress: String, vc: MapViewController) {
        vc.dismiss(animated: true, completion: nil)
        self.teamPlace = placeName
        self.placeLatitude = location[0]
        self.placeLongitude = location[1]
        self.placeTextField.text = placeName
        self.placeAddress = placeAddress
    }
    func dismissMapVC(vc: MapViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

//    @IBAction func finishAction(_ sender: Any) {
//        guard let image = eventImage else { return }
//        StorageService.addEventImage(image: image) { urlString in
//            self.dic["urlEventString"] = urlString
//            EventServie.sendEventData(teamId: self.teamId, event: self.dic, eventId: self.eventId) { result in
//                switch result {
//                case .success:
//                    EventServie.sendEventTagData(eventId: self.eventId, tags: self.plusTagArray, teamId: self.teamId)
//                    self.navigationController?.popToRootViewController(animated: true)
//                case .failure(let error):
//                    let message = self.setupFirestoreErrorMessage(error: error as! NSError)
//                    self.setupCDAlert(title: "イベント作成に失敗しました", message: message, action: "OK", alertType: .warning)
//                }
//            }
//        }
//    }

//    func rangeIsChanging(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
//        switch minValueSelected {
//        case 0..<1:
//            minLevelLabel.text = BadmintonLevel.one.rawValue
//        case 1..<2:
//            minLevelLabel.text = BadmintonLevel.two.rawValue
//        case 2..<3:
//            minLevelLabel.text = BadmintonLevel.three.rawValue
//        case 3..<4:
//            minLevelLabel.text = BadmintonLevel.four.rawValue
//        case 4..<5:
//            minLevelLabel.text = BadmintonLevel.five.rawValue
//        case 5..<6:
//            minLevelLabel.text = BadmintonLevel.six.rawValue
//        case 6..<7:
//            minLevelLabel.text = BadmintonLevel.seven.rawValue
//        case 7..<8:
//            minLevelLabel.text = BadmintonLevel.eight.rawValue
//        case 8..<9:
//            minLevelLabel.text = BadmintonLevel.nine.rawValue
//        case 9..<10:
//            minLevelLabel.text = BadmintonLevel.ten.rawValue
//        default:
//            break
//        }
//        switch maxValueSelected {
//        case 0..<1:
//            maxLevelLabel.text = BadmintonLevel.one.rawValue
//        case 1..<2:
//            maxLevelLabel.text = BadmintonLevel.two.rawValue
//        case 2..<3:
//            maxLevelLabel.text = BadmintonLevel.three.rawValue
//        case 3..<4:
//            maxLevelLabel.text = BadmintonLevel.four.rawValue
//        case 4..<5:
//            maxLevelLabel.text = BadmintonLevel.five.rawValue
//        case 5..<6:
//            maxLevelLabel.text = BadmintonLevel.six.rawValue
//        case 6..<7:
//            maxLevelLabel.text = BadmintonLevel.seven.rawValue
//        case 7..<8:
//            maxLevelLabel.text = BadmintonLevel.eight.rawValue
//        case 8..<9:
//            maxLevelLabel.text = BadmintonLevel.nine.rawValue
//        case 9..<10:
//            maxLevelLabel.text = BadmintonLevel.ten.rawValue
//        default:
//            break
//        }
//    }
