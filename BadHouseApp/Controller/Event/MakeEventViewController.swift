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
    @IBOutlet private weak var startPicker: UIDatePicker!
    @IBOutlet private weak var finishPicker: UIDatePicker!
    @IBOutlet private weak var maxLevelLabel: UILabel!
    @IBOutlet private weak var minLevelLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            tfupdate(view: titleTextField)
            titleTextField.returnKeyType = .next
            titleTextField.keyboardType = .namePhonePad
        }
    }
    @IBOutlet private weak var datePicker: UIDatePicker!
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
    
    //Mark:sendEventdataProperties
    private var selectedTeam:TeamModel?
    private var (teamPlace,teamTime) = (String(),String())
    private var (eventTitle,eventStartTime,eventLastTime,eventLevel,eventMoney,courtCount,gatherCount,detailText,placeAddress) = (String(),String(),String(),String(),String(),String(),String(),String(),String())
    private var kindCircle = "学生サークル"
    private var (placeLatitude,placeLongitude) = (Double(),Double())
    private var dic = [String:Any]()
    private var team:TeamModel?
    @IBOutlet weak var levelUISlider: RangeUISlider! {
        didSet {
            levelUISlider.leftKnobColor = Utility.AppColor.OriginalBlue
            levelUISlider.rightKnobColor = Utility.AppColor.OriginalBlue
            levelUISlider.rangeSelectedColor = Utility.AppColor.OriginalBlue
        }
    }
    private let moneyArray = Utility.Data.moneyArray
    private let moneyPickerView = UIPickerView()
    private let fetchData = FetchFirestoreData()
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupBinding()
        setupOwnTeamData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    
    private func tfupdate(view:UIView) {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    //Mark setupUI
    private func setupDelegate() {
        levelUISlider.delegate = self
        TeamPickerView.delegate = self
        TeamPickerView.dataSource = self
        moneyPickerView.delegate = self
        moneyPickerView.dataSource = self
        fetchData.myTeamDelegate = self
        moneyTextField.inputView = moneyPickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButtonItem], animated: true)
        moneyTextField.inputAccessoryView = toolBar
    }
    //Mark selector
    @objc private func donePicker() {
        moneyTextField.endEditing(true)
    }
    
    //Mark:MapDelegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoMap {
            let nextVC = segue.destination as! MapViewController
            nextVC.delegate = self
        }
    }
    
    //Mark:SetupBinding
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
                let text = text ?? ""
                self.eventMoney = text
                self.eventBinding.moneyTextInput.onNext(text)
            }
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.asDriver()
            .drive { [weak self] text in
                guard let self = self else { return }
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
                    Utility.AppColor.OriginalBlue:.darkGray
            }
            .disposed(by: disposeBag)
    }
    
    //Mark setupTeamData
    private func setupOwnTeamData() {
        let uid = Auth.getUserId()
        Firestore.getOwnTeam(uid: uid) { [weak self] teamIds in
            guard let self = self else { return }
            self.fetchData.getmyTeamData(idArray: teamIds)
        }
    }
    
    //Mark:Selector
    @objc private func segmentTap(sender:UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            kindCircle = "学生サークル"
        case 1:
            kindCircle = "社会人サークル"
        case 2:
            kindCircle = "その他練習"
        default:
            break
        }
    }
    
    @objc private func createEvent() {
        print(#function)
        var teamImageUrl = String()
        guard let teamId = selectedTeam?.teamId else { return }
        Firestore.getTeamData(teamId: teamId) { [weak self] teamData in
            guard let self = self else { return }
            self.team = teamData
            teamImageUrl = self.team?.teamImageUrl ?? ""
        }
        guard let teamName = selectedTeam?.teamName else { return }
        let max = maxLevelLabel.text ?? "レベル6"
        let min = minLevelLabel.text ?? "レベル2"
        eventLevel = min + "~" + max
        courtCount = courtCountLabel.text ?? "1"
        gatherCount = gatherCountLabel.text ?? "1"
        detailText = detaiTextView.text ?? ""
      
        let userId = Auth.getUserId()
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.TagVC) as! TagViewController
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
        performSegue(withIdentifier: Utility.Segue.gotoMap, sender: nil)
    }
    
    //Mark: MapDelegateMethod
    func sendLocationData(location: [Double], placeName: String,placeAddress:String) {
        self.teamPlace = placeName
        self.placeLatitude = location[0]
        self.placeLongitude = location[1]
        self.placeTextField.text = placeName
        self.placeAddress = placeAddress
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
            minLevelLabel.text = "レベル1"
        case 1..<2:
            minLevelLabel.text = "レベル2"
        case 2..<3:
            minLevelLabel.text = "レベル3"
        case 3..<4:
            minLevelLabel.text = "レベル4"
        case 4..<5:
            minLevelLabel.text = "レベル5"
        case 5..<6:
            minLevelLabel.text = "レベル6"
        case 6..<7:
            minLevelLabel.text = "レベル7"
        case 7..<8:
            minLevelLabel.text = "レベル8"
        case 8..<9:
            minLevelLabel.text = "レベル9"
        case 9..<10:
            minLevelLabel.text = "レベル10"
        default:
            break
        }
       
        switch maxValueSelected {
        case 0..<1:
            maxLevelLabel.text = "レベル1"
        case 1..<2:
            maxLevelLabel.text = "レベル2"
        case 2..<3:
            maxLevelLabel.text = "レベル3"
        case 3..<4:
            maxLevelLabel.text = "レベル4"
        case 4..<5:
            maxLevelLabel.text = "レベル5"
        case 5..<6:
            maxLevelLabel.text = "レベル6"
        case 6..<7:
            maxLevelLabel.text = "レベル7"
        case 7..<8:
            maxLevelLabel.text = "レベル8"
        case 8..<9:
            maxLevelLabel.text = "レベル9"
        case 9..<10:
            maxLevelLabel.text = "レベル10"
        default:
            break
        }
    }
}

extension MakeEventViewController:UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            noImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension MakeEventViewController :GetMyTeamDelegate {
    func getMyteam(teamArray: [TeamModel]) {
        pickerArray = teamArray
        if pickerArray.count == 1 {
            self.selectedTeam = pickerArray[0]
        }
        TeamPickerView.reloadAllComponents()
    }
    
    
}
