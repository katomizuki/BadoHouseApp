import UIKit

protocol getDetailDelegate:AnyObject {
    func getDetailElement(title:String,
                          circle:String,
                          level:String,
                          placeAddressString:String,
                          money:String,
                          time:String)
}

class DetailSearchViewController: UIViewController{
    
    //Mark:Properties
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var circleStackView: UIStackView!
    @IBOutlet private weak var levelStackView: UIStackView!
    @IBOutlet private weak var cityStackView: UIStackView!
    @IBOutlet private weak var moneyStackView: UIStackView!
    @IBOutlet private weak var timeStackView: UIStackView!
    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            titleTextField.keyboardType = .namePhonePad
            titleTextField.returnKeyType = .next
        }
    }
    @IBOutlet private weak var circleTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField! {
        didSet {
            cityTextField.keyboardType = .namePhonePad
            cityTextField.returnKeyType = .next
        }
    }
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var levelTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    private let (pickerView,pickerMoneyView,pickerLevelView,placePickerView ) = (UIPickerView(),UIPickerView(),UIPickerView(),UIPickerView())
    private let (data,place,money,level) = (Utility.Data.circle,Utility.Data.place,Utility.Data.money,Utility.Data.level)
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var datePicker: UIDatePicker!
    private var dateString = String()
    private var eventArray = [Event]()
    weak var delegate:getDetailDelegate?
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark:StackView UnderLine
        setupUnderLayer(view: titleStackView)
        setupUnderLayer(view: circleStackView)
        setupUnderLayer(view: levelStackView)
        setupUnderLayer(view: cityStackView)
        setupUnderLayer(view: moneyStackView)
        setupUnderLayer(view: timeStackView)
        setupPickerView()
        updateUI()
        setupBorder()
    }
    
    //Mark updateUI
    private func updateUI() {
        datePicker.addTarget(self, action: #selector(getDate(sender:)), for: UIControl.Event.valueChanged)
        searchButton.layer.cornerRadius = 15
        searchButton.layer.masksToBounds = true
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
    
    //Mark:setupPickerView
    private func setupPickerView() {
        setPicker(pickerView: pickerView, textField: circleTextField)
        setPicker(pickerView: pickerMoneyView, textField: moneyTextField)
        setPicker(pickerView: pickerLevelView, textField: levelTextField)
    }
    
    //Mark:setPicker
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
    @objc func donePicker() {
        circleTextField.endEditing(true)
        moneyTextField.endEditing(true)
        levelTextField.endEditing(true)
    }
    
    @objc func getDate(sender:UIDatePicker) {
        let dateString = self.formatterUtil(date: sender.date)
        self.dateString = dateString
    }
    
    //Mark:TextFieldMethod
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        circleTextField.endEditing(true)
        moneyTextField.endEditing(true)
        levelTextField.endEditing(true)
    }
    
    //Mark:IBAction
    @IBAction private func search(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let circle = circleTextField.text ?? ""
        let level = levelTextField.text ?? ""
        let money = moneyTextField.text ?? ""
        let time = self.dateString
        let placeAddressString = cityTextField.text ?? ""
        self.delegate?.getDetailElement(title: title, circle: circle, level: level, placeAddressString: placeAddressString, money: money, time: time)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBorder() {
        helperTextfield(textfield: titleTextField)
        helperTextfield(textfield: moneyTextField)
        helperTextfield(textfield: cityTextField)
        helperTextfield(textfield: levelTextField)
        helperTextfield(textfield: circleTextField)
    }
    
    private func helperTextfield(textfield:UITextField) {
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 2
        textfield.toCorner(num: 15)
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
        } else if pickerView == self.pickerMoneyView {
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




