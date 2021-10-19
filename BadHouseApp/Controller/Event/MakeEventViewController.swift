import UIKit
import RxSwift
import RxCocoa
import Firebase
import RangeUISlider

class MakeEventViewController: UIViewController ,UIImagePickerControllerDelegate,SearchLocationProtocol{
    //Mark:properties
    @IBOutlet private weak var gatherCountLabel: UILabel!
    @IBOutlet private weak var courtCountLabel: UILabel!
    @IBOutlet private weak var moneyTextField: UITextField! {
        didSet {
            tfupdate(view: moneyTextField)
        }
    }
    @IBOutlet private weak var startPicker: UIDatePicker! {
        didSet {
            startPicker.locale = Locale(identifier: "ja-JP")
        }
    }
    @IBOutlet private weak var finishPicker: UIDatePicker! {
        didSet {
            finishPicker.locale = Locale(identifier: "ja-JP")
        }
    }
    @IBOutlet private weak var maxLevelLabel: UILabel!
    @IBOutlet private weak var minLevelLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            tfupdate(view: titleTextField)
            titleTextField.returnKeyType = .next
            titleTextField.keyboardType = .namePhonePad
            titleTextField.toCorner(num: 15)
            titleTextField.placeholder = "タイトル名記入"
        }
    }
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.locale = Locale(identifier: "ja-JP")
        }
    }
    @IBOutlet private weak var TeamPickerView: UIPickerView! {
        didSet {
            TeamPickerView.toCorner(num: 15)
        }
    }
    @IBOutlet private weak var placeTextField: UITextField! {
        didSet {
            tfupdate(view: placeTextField)
        }
    }
    private let eventBinding = MakeEventBindings()
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var makeEventButton: UIButton! {
        didSet {
            makeEventButton.toCorner(num: 15)
            makeEventButton.setTitleColor(.white, for: .normal)
            makeEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        }
    }
    private var pickerArray = [TeamModel]()
    @IBOutlet private weak var detaiTextView: UITextView! {
        didSet {
            tfupdate(view: detaiTextView)
            detaiTextView.keyboardType = .namePhonePad
        }
    }
    @IBOutlet private weak var circleSegment: UISegmentedControl! {
        didSet {
            circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
        }
    }
    @IBOutlet private weak var noImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            scrollView.addGestureRecognizer(gesture)
        }
    }
    private var selectedTeam:TeamModel?
    private var (teamPlace,teamTime) = (String(),String())
    private var (eventTitle,eventStartTime,eventLastTime,eventLevel,eventMoney,courtCount,gatherCount,detailText,placeAddress) = (String(),String(),String(),String(),String(),String(),String(),String(),String())
    private var kindCircle = BadmintonCircle.student.rawValue
    private var (placeLatitude,placeLongitude) = (Double(),Double())
    private var dic = [String:Any]()
    private var team:TeamModel?
    @IBOutlet weak var levelUISlider: RangeUISlider! {
        didSet {
            levelUISlider.leftKnobColor = Constants.AppColor.OriginalBlue
            levelUISlider.rightKnobColor = Constants.AppColor.OriginalBlue
            levelUISlider.rangeSelectedColor = Constants.AppColor.OriginalBlue
        }
    }
    private let moneyArray = Constants.Data.moneyArray
    private let moneyPickerView = UIPickerView()
    private let fetchData = FetchFirestoreData()
    //Mark:LifeCycle
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
    //Mark setupMethod
    private func setupDelegate() {
        levelUISlider.delegate = self
        TeamPickerView.delegate = self
        TeamPickerView.dataSource = self
        moneyPickerView.delegate = self
        moneyPickerView.dataSource = self
        fetchData.myTeamDelegate = self
        titleTextField.delegate = self
    }
    
    private func setupToolBar() {
        moneyTextField.inputView = moneyPickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleButton,doneButtonItem], animated: true)
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
            .disposed(by:disposeBag)
        
        finishPicker.rx.value.changed
            .asObservable()
            .subscribe (onNext: { [weak self] data in
                guard let self = self else { return }
                let string = self.formatterUtil(date: data)
                self.eventLastTime = string
                self.eventBinding.finishTextInput.onNext(string)
            })
            .disposed(by: disposeBag)
        
        startPicker.rx.value.changed
            .asObservable()
            .subscribe (onNext:{ [weak self] data in
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
                self.titleTextField.layer.borderWidth = text?.count == 0 ? 2 : 3
                let title = text ?? ""
                self.eventTitle = title
                self.eventBinding.titleTextInput.onNext(title)
            }
            .disposed(by:disposeBag)
        
        TeamPickerView.rx.itemSelected.asObservable()
            .subscribe { [weak self] element in
                guard let self = self else { return }
                if let data = element.element {
                    let index = data.row
                    let teamName = self.pickerArray[index].teamName
                    self.eventBinding.groupTextInput.onNext(teamName)
                    self.selectedTeam = self.pickerArray[index]
                }
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
            self.fetchData.getmyTeamData(idArray: teamIds)
        }
    }
    //Mark:Selector
    @objc private func segmentTap(sender:UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            kindCircle = BadmintonCircle.student.rawValue
        case 1:
            kindCircle = BadmintonCircle.society.rawValue
        case 2:
            kindCircle = BadmintonCircle.other.rawValue
        default:
            break
        }
    }
    @objc private func handleTap() {
        titleTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        detaiTextView.resignFirstResponder()
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
            teamImageUrl = self.team?.teamImageUrl ?? ""
        }
        guard let teamName = selectedTeam?.teamName else { return }
        let max = maxLevelLabel.text ?? BadmintonLevel.six.rawValue
        let min = minLevelLabel.text ?? BadmintonLevel.two.rawValue
        eventLevel = min + "~" + max
        courtCount = courtCountLabel.text ?? "1"
        gatherCount = gatherCountLabel.text ?? "1"
        detailText = detaiTextView.text ?? ""
        let userId = AuthService.getUserId()
        let eventId = Ref.EventRef.document().documentID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let dic = ["eventId":eventId,
                       "time":self.teamTime,
                       "place":self.teamPlace,
                       "teamId":teamId,
                       "teamName":teamName,
                       "eventStartTime":self.eventStartTime,
                       "eventLastTime":self.eventLastTime,
                       "eventLavel":self.eventLevel,
                       "eventMoney":self.eventMoney,
                       "detailText":self.detailText,
                       "kindCircle":self.kindCircle,
                       "courtCount":self.courtCount,
                       "gatherCount":self.gatherCount,
                       "eventTitle":self.eventTitle,
                       "latitude":self.placeLatitude,
                       "longitude":self.placeLongitude,
                       "teamImageUrl":teamImageUrl,
                       "placeAddress":self.placeAddress,
                       "userId":userId] as [String : Any]
            guard let eventImage = self.noImageView.image else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.TagVC) as! TagViewController
            vc.dic = dic
            vc.teamId = teamId
            vc.eventId = eventId
            vc.eventImage = eventImage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //Mark:IBAction
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
        performSegue(withIdentifier: Constants.Segue.gotoMap, sender: nil)
    }
    //Mark helperMethod
    private func tfupdate(view:UIView) {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    //Mark: MapDelegateMethod
    func sendLocationData(location: [Double], placeName: String,placeAddress:String,vc:MapViewController) {
        vc.dismiss(animated: true, completion: nil)
        self.teamPlace = placeName
        self.placeLatitude = location[0]
        self.placeLongitude = location[1]
        self.placeTextField.text = placeName
        self.placeAddress = placeAddress
    }
    //Mark:Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.gotoMap {
            let nextVC = segue.destination as! MapViewController
            nextVC.delegate = self
        }
    }
}
//Mark: UIPickerViewDelegate
extension MakeEventViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.TeamPickerView {
            return pickerArray.count
        } else {
            return moneyArray.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.TeamPickerView {
            return pickerArray[row].teamName
        } else {
            return moneyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == moneyPickerView {
            moneyTextField.text = moneyArray[row]
        }
    }
}
//Mark: RangeUISliderDelegate
extension MakeEventViewController:RangeUISliderDelegate{
    //Mark RangeDelegate
    func rangeChangeFinished(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
    }
    
    func rangeIsChanging(minValueSelected: CGFloat, maxValueSelected: CGFloat, slider: RangeUISlider) {
        switch minValueSelected {
        case 0..<1:
            minLevelLabel.text = BadmintonLevel.one.rawValue
        case 1..<2:
            minLevelLabel.text = BadmintonLevel.two.rawValue
        case 2..<3:
            minLevelLabel.text = BadmintonLevel.three.rawValue
        case 3..<4:
            minLevelLabel.text = BadmintonLevel.four.rawValue
        case 4..<5:
            minLevelLabel.text = BadmintonLevel.five.rawValue
        case 5..<6:
            minLevelLabel.text = BadmintonLevel.six.rawValue
        case 6..<7:
            minLevelLabel.text = BadmintonLevel.seven.rawValue
        case 7..<8:
            minLevelLabel.text = BadmintonLevel.eight.rawValue
        case 8..<9:
            minLevelLabel.text = BadmintonLevel.nine.rawValue
        case 9..<10:
            minLevelLabel.text = BadmintonLevel.ten.rawValue
        default:
            break
        }
        
        switch maxValueSelected {
        case 0..<1:
            maxLevelLabel.text = BadmintonLevel.one.rawValue
        case 1..<2:
            maxLevelLabel.text = BadmintonLevel.two.rawValue
        case 2..<3:
            maxLevelLabel.text = BadmintonLevel.three.rawValue
        case 3..<4:
            maxLevelLabel.text = BadmintonLevel.four.rawValue
        case 4..<5:
            maxLevelLabel.text = BadmintonLevel.five.rawValue
        case 5..<6:
            maxLevelLabel.text = BadmintonLevel.six.rawValue
        case 6..<7:
            maxLevelLabel.text = BadmintonLevel.seven.rawValue
        case 7..<8:
            maxLevelLabel.text = BadmintonLevel.eight.rawValue
        case 8..<9:
            maxLevelLabel.text = BadmintonLevel.nine.rawValue
        case 9..<10:
            maxLevelLabel.text = BadmintonLevel.ten.rawValue
        default:
            break
        }
    }
}
//Mark:uinavigationDelegate
extension MakeEventViewController:UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            noImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
//Mark getmyTeamDelegate
extension MakeEventViewController :GetMyTeamDelegate {
    func getMyteam(teamArray: [TeamModel]) {
        pickerArray = teamArray
        if pickerArray.count == 1 {
            self.selectedTeam = pickerArray[0]
        }
        TeamPickerView.reloadAllComponents()
    }
}
//Mark textFieldDelegate
extension MakeEventViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
