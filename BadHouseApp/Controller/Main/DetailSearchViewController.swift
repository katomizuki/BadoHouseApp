

import UIKit

protocol getDetailDelegate {
    func getDetailElement(title:String,circle:String,level:String,placeAddressString:String,money:String,time:String)
}

class DetailSearchViewController: UIViewController{
    
    //Mark:Properties
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var circleStackView: UIStackView!
    @IBOutlet weak var levelStackView: UIStackView!
    @IBOutlet weak var preferenceStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var wardStackView: UIStackView!
    @IBOutlet weak var moneyStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var circleTextField: UITextField!
    @IBOutlet weak var prefrenceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var wardTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    private var pickerView = UIPickerView()
    private var pickerMoneyView = UIPickerView()
    private var pickerLevelView = UIPickerView()
    private var city = ["川崎市,横浜市"]
    private var data = ["学生サークル", "社会人サークル", "その他練習"]
    private var place = ["神奈川県"]
    private var money = ["500円~1000円","1000円~2000円","2000円~"]
    private var level = ["レベル1","レベル2","レベル3","レベル4","レベル5","レベル6","レベル7","レベル8","レベル9","レベル10"]
    private let fetchData = FetchFirestoreData()
    @IBOutlet weak var datePicker: UIDatePicker!
    private var dateString = String()
    private var eventArray = [Event]()
    var delegate:getDetailDelegate?
    

    
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark:StackView UnderLine
        setupUnderLayer(view: titleStackView)
        setupUnderLayer(view: circleStackView)
        setupUnderLayer(view: levelStackView)
        setupUnderLayer(view: preferenceStackView)
        setupUnderLayer(view: cityStackView)
        setupUnderLayer(view: wardStackView)
        setupUnderLayer(view: moneyStackView)
        setupUnderLayer(view: timeStackView)
        setupPickerView()
        datePicker.addTarget(self, action: #selector(getDate(sender:)), for: UIControl.Event.valueChanged)
        
    }
    
    //Mark:getCGrect
    private func getCGrect(view:UIView)->CGRect {
        return CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 1.0)
    }
    
    
    //Mark:setupMethod
    private func setupUnderLayer(view:UIView) {
        let bottomBorder = CALayer()
        bottomBorder.frame = self.getCGrect(view: view)
        bottomBorder.backgroundColor = Utility.AppColor.OriginalBlue.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    private func setupPickerView() {
        setPicker(pickerView: pickerView, textField: circleTextField)
        setPicker(pickerView: pickerMoneyView, textField: moneyTextField)
        setPicker(pickerView: pickerLevelView, textField: levelTextField)
    }
    
    private func setPicker(pickerView:UIPickerView,textField:UITextField) {
        pickerView.delegate = self
        textField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButtonItem], animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    //Mark:Selector
    @objc private func donePicker() {
        circleTextField.endEditing(true)
        moneyTextField.endEditing(true)
        levelTextField.endEditing(true)
    }
    @objc func getDate(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateString = formatter.string(from: sender.date)
        self.dateString = dateString
    }
    
    //Mark:TextFieldMethod
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        circleTextField.endEditing(true)
        moneyTextField.endEditing(true)
        levelTextField.endEditing(true)
    }
    
    
    //Mark:IBAction
    @IBAction func search(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let circle = circleTextField.text ?? ""
        let level = levelTextField.text ?? ""
        let money = moneyTextField.text ?? ""
        let time = self.dateString
        let prefrence = prefrenceTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let ward = cityTextField.text ?? ""
        let placeAddressString = prefrence + city + ward
        
        self.delegate?.getDetailElement(title: title, circle: circle, level: level, placeAddressString: placeAddressString, money: money, time: time)
        dismiss(animated: true, completion: nil)
    }
}

//Mark:PickerViewDelegate
extension DetailSearchViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return data.count
        } else if pickerView == self.pickerMoneyView {
            return money.count
        } else {
            return level.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return self.data[row]
        } else if pickerView == self.pickerMoneyView{
            return self.money[row]
        } else {
            return self.level[row]
        }
      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            circleTextField.text = data[row]
        } else if pickerView == self.pickerMoneyView {
            moneyTextField.text = money[row]
        } else {
            levelTextField.text = level[row]
        }
    }
}




