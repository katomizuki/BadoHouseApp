

import UIKit
import RxSwift
import RxCocoa
import Firebase

class MakeEventViewController: UIViewController {
    
    
    
    //Mark:properties
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var TeamPickerView: UIPickerView!
    @IBOutlet weak var placeTextField: UITextField!
    private let eventBinding = MakeEventBindings()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var makeEventButton: UIButton!
    
    var pickerArray = [TeamModel]()
    
    lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    //Mark:sendEventdataProperties
    var selectedTeam:TeamModel?
    var teamPlace = ""
    var teamTime = ""
    var dic = [String:Any]()
    
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        placeTextField.placeholder = "住所"
        TeamPickerView.delegate = self
        TeamPickerView.dataSource = self
        setupBinding()
        setupOwnTeamData()
        makeEventButton.addTarget(self, action: #selector(createEvent), for: UIControl.Event.touchUpInside)
    }
    
    private func setupBinding() {
        
        datePicker.rx.value.changed
            .asObservable()
            .subscribe(onNext: { date in
                let string = self.dateFormatter.string(from: date)
                self.eventBinding.dateTextInput.onNext(string)
                self.teamTime = string
            })
            .disposed(by:disposeBag)
        
        TeamPickerView.rx.itemSelected.asObservable()
            .subscribe { element in
                if let data = element.element {
                    let index = data.row
                    let teamName = self.pickerArray[index].teamName
                    self.placeTextField.text = self.pickerArray[index].teamPlace
                    self.eventBinding.groupTextInput.onNext(teamName)
                    self.selectedTeam = self.pickerArray[index]
                }
            }
            .disposed(by: disposeBag)
        
        placeTextField.rx.text.asDriver()
            .drive { text in
                self.eventBinding.placeTextInput.onNext(text ?? "")
                self.teamPlace = text ?? ""
            }
            .disposed(by: disposeBag)
        
        eventBinding.valideMakeDriver
            .drive { validAll in
                print(validAll)
                self.makeEventButton.isEnabled = validAll
                self.makeEventButton.backgroundColor = validAll ?
                    Utility.AppColor.StandardColor:.darkGray
            }
            .disposed(by: disposeBag)
    }
    
    private func setupOwnTeamData() {
        let uid = Auth.getUserId()
        Firestore.getOwnTeam(uid: uid) { teams in
            self.pickerArray = teams
            self.TeamPickerView.reloadAllComponents()
        }
    }
    
    @objc private func createEvent() {
        print(#function)
        let place = teamPlace
        let time = teamTime
        
        guard let teamId = selectedTeam?.teamId else { return }
        guard let teamName = selectedTeam?.teamName else { return }
        let eventId = Ref.EventRef.document().documentID
        let dic = ["eventId":eventId,"time":time,"place":place,"teamId":teamId,"teamName":teamName]
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.TagVC) as! TagViewController
        vc.dic = dic
        vc.teamId = teamId
        vc.eventId = eventId
        navigationController?.pushViewController(vc, animated: true)
    }
    
  
}
extension MakeEventViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row].teamName
    }
    
    
}
