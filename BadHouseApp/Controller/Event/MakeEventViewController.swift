import UIKit
import RxSwift
import RxCocoa
import Firebase
import RangeUISlider
//import FacebookCore


class MakeEventViewController: UIViewController ,UIImagePickerControllerDelegate,SearchLocationProtocol{
    
    //Mark:properties
    @IBOutlet weak var gatherCountLabel: UILabel!
    @IBOutlet weak var courtCountLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var finishPicker: UIDatePicker!
    @IBOutlet weak var maxLevelLabel: UILabel!
    @IBOutlet weak var minLevelLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var TeamPickerView: UIPickerView!
    @IBOutlet weak var placeTextField: UITextField!
    private let eventBinding = MakeEventBindings()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var makeEventButton: UIButton!
    var pickerArray = [TeamModel]()
    @IBOutlet weak var detaiTextView: UITextView!
    @IBOutlet weak var circleSegment: UISegmentedControl!
    @IBOutlet weak var noImageView: UIImageView!
    
    //Mark:sendEventdataProperties
    private var selectedTeam:TeamModel?
    private var teamPlace = String()
    private var teamTime = String()
    private var eventTitle = String()
    private var eventStartTime = String()
    private var eventLastTime = String()
    private var kindCircle = "学生サークル"
    private var eventLavel = String()
    private var eventMoney = String()
    private var courtCount = String()
    private var gatherCount = String()
    private var detailText = String()
    private var placeAddress = String()
    private var placeLatitude = Double()
    private var placeLongitude = Double()
    private var dic = [String:Any]()
    private var team:TeamModel?
    @IBOutlet weak var levelUISlider: RangeUISlider!
    private let moneyArray = Utility.Data.moneyArray
    private let moneyPickerView = UIPickerView()
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupOwnTeamData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage(named: Utility.ImageName.double)
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:Utility.AppColor.OriginalBlue]
    }
    
    private func tfupdate(tf:UITextField) {
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 15
        tf.layer.masksToBounds = true
    }
    
    //Mark setupUI
    private func setupUI() {
        TeamPickerView.layer.cornerRadius = 15
        TeamPickerView.layer.masksToBounds = true
        detaiTextView.layer.cornerRadius = 15
        detaiTextView.layer.borderColor = UIColor.lightGray.cgColor
        detaiTextView.layer.masksToBounds = true
        detaiTextView.layer.borderWidth = 2
        
        levelUISlider.delegate = self
        levelUISlider.leftKnobColor = Utility.AppColor.OriginalBlue
        levelUISlider.rightKnobColor = Utility.AppColor.OriginalBlue
        levelUISlider.rangeSelectedColor = Utility.AppColor.OriginalBlue
        makeEventButton.setTitleColor(.white, for: UIControl.State.normal)
        makeEventButton.layer.cornerRadius = 15
        makeEventButton.layer.masksToBounds = true
        
        tfupdate(tf: titleTextField)
        tfupdate(tf: placeTextField)
        tfupdate(tf: moneyTextField)
        
        TeamPickerView.delegate = self
        TeamPickerView.dataSource = self
        moneyPickerView.delegate = self
        moneyPickerView.dataSource = self
        moneyTextField.inputView = moneyPickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButtonItem], animated: true)
        moneyTextField.inputAccessoryView = toolBar
        
        makeEventButton.addTarget(self, action: #selector(createEvent), for: UIControl.Event.touchUpInside)
        circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
    }
    //Mark selector
    @objc func donePicker() {
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
            .subscribe(onNext: { date in
                let string = self.formatterUtil(date: date)
                self.eventBinding.dateTextInput.onNext(string)
                self.teamTime = string
            })
            .disposed(by:disposeBag)
        
        finishPicker.rx.value.changed
            .asObservable()
            .subscribe (onNext: { data in
                let string = self.formatterUtil(date: data)
                self.eventLastTime = string
                self.eventBinding.finishTextInput.onNext(string)
            })
            .disposed(by: disposeBag)
        
        startPicker.rx.value.changed
            .asObservable()
            .subscribe (onNext:{ data in

                let string = self.formatterUtil(date: data)
               
                self.eventStartTime = string
                self.eventBinding.startTextInput.onNext(string)
            })
            .disposed(by: disposeBag)

        moneyTextField.rx.text.asDriver()
            .drive { text in
                let text = text ?? ""
                self.eventMoney = text
                self.eventBinding.moneyTextInput.onNext(text)
            }
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.asDriver()
            .drive { text in
                let title = text ?? ""
                self.eventTitle = title
                self.eventBinding.titleTextInput.onNext(title)
            }
            .disposed(by:disposeBag)

        TeamPickerView.rx.itemSelected.asObservable()
            .subscribe { element in
                if let data = element.element {
                    let index = data.row
                    let teamName = self.pickerArray[index].teamName
                    self.eventBinding.groupTextInput.onNext(teamName)
                    self.selectedTeam = self.pickerArray[index]
                }
            }
            .disposed(by: disposeBag)
        
        
        eventBinding.valideMakeDriver
            .drive { validAll in
                print(validAll)
                self.makeEventButton.isEnabled = validAll
                self.makeEventButton.backgroundColor = validAll ?
                    Utility.AppColor.OriginalBlue:.darkGray
            }
            .disposed(by: disposeBag)
    }
    
    //Mark setupTeamData
    private func setupOwnTeamData() {
        let uid = Auth.getUserId()
        Firestore.getOwnTeam(uid: uid) { teams in
            self.pickerArray = teams
            self.TeamPickerView.reloadAllComponents()
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
        Firestore.getTeamData(teamId: teamId) { teamData in
            self.team = teamData
            teamImageUrl = self.team?.teamImageUrl ?? ""
        }
        guard let teamName = selectedTeam?.teamName else { return }
        let max = maxLevelLabel.text ?? "レベル6"
        let min = minLevelLabel.text ?? "レベル2"
        eventLavel = min + "~" + max
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
                       "eventLavel":self.eventLavel,
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
    @IBAction func plusCourt(_ sender: UIStepper) {
        let num = String(Int(sender.value) + 1)
        courtCountLabel.text = num
    }
    @IBAction func plusGather(_ sender: UIStepper) {
        let num = String(Int(sender.value))
        gatherCountLabel.text = num
    }
    @IBAction func plusImage(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func gotoMap(_ sender: Any) {
        print(#function)
        performSegue(withIdentifier: "gotoMap", sender: nil)
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



