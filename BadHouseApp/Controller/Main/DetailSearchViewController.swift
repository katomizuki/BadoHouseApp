import UIKit
import grpc
import FacebookCore

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
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            scrollView.addGestureRecognizer(gesture)
        }
    }
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
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.layer.cornerRadius = 15
            searchButton.layer.masksToBounds = true
        }
    }
    private let (pickerView,pickerMoneyView,pickerLevelView,placePickerView ) = (UIPickerView(),UIPickerView(),UIPickerView(),UIPickerView())
    private let (data,place,money,level) = (Utility.Data.circle,Utility.Data.place,Utility.Data.money,Utility.Data.level)
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.addTarget(self, action: #selector(getDate(sender:)), for: .valueChanged)
            datePicker.locale = Locale(identifier: "ja-JP")
        }
    }
    private var dateString = String()
    private var eventArray = [Event]()
    weak var delegate:getDetailDelegate?
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayer()
        setupPickerView()
        setupBorder()
        setupAddtarget()
        setupDelegate()
    }
    
    //Mark:setupMethod
    private func setupLayer() {
        setupUnderLayer(view: titleStackView)
        setupUnderLayer(view: circleStackView)
        setupUnderLayer(view: levelStackView)
        setupUnderLayer(view: cityStackView)
        setupUnderLayer(view: moneyStackView)
        setupUnderLayer(view: timeStackView)
    }
    
    private func setupDelegate() {
        titleTextField.delegate = self
        cityTextField.delegate = self
    }
    
    private func setupAddtarget() {
        titleTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        circleTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        levelTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        moneyTextField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
    }
    
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

    private func setupBorder() {
        helperTextfield(textfield: titleTextField)
        helperTextfield(textfield: moneyTextField)
        helperTextfield(textfield: cityTextField)
        helperTextfield(textfield: levelTextField)
        helperTextfield(textfield: circleTextField)
    }
    //Mark HelperMethod
    private func helperTextfield(textfield:UITextField) {
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 2
        textfield.toCorner(num: 15)
    }
    private func getCGrect(view:UIView)->CGRect {
        return CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 1.0)
    }
    
    //Mark:SelectorMethod
    @objc private func donePicker() {
        circleTextField.endEditing(true)
        moneyTextField.endEditing(true)
        levelTextField.endEditing(true)
    }
    
    @objc private func getDate(sender:UIDatePicker) {
        let dateString = self.formatterUtil(date: sender.date)
        self.dateString = dateString
    }
    
    @objc private func handleTap() {
        print(#function)
        titleTextField.resignFirstResponder()
        circleTextField.resignFirstResponder()
        levelTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
    }
    
    @objc private func handleChange(sender:UITextField) {
        switch sender {
        case titleTextField:
            titleTextField.layer.borderColor = titleTextField.text?.count == 0 ? UIColor.lightGray.cgColor :
            Utility.AppColor.OriginalBlue.cgColor
            titleTextField.layer.borderWidth = titleTextField.text?.count == 0 ? 2 : 3
        case circleTextField:
            circleTextField.layer.borderColor = circleTextField.text?.count == 0 ? UIColor.lightGray.cgColor : Utility.AppColor.OriginalBlue.cgColor
            circleTextField.layer.borderWidth = circleTextField.text?.count == 0 ? 2 : 3
        case levelTextField:
            levelTextField.layer.borderColor = levelTextField.text?.count == 0 ? UIColor.lightGray.cgColor : Utility.AppColor.OriginalBlue.cgColor
            levelTextField.layer.borderWidth = levelTextField.text?.count == 0 ? 2 : 3
        case cityTextField:
            cityTextField.layer.borderColor = cityTextField.text?.count == 0 ? UIColor.lightGray.cgColor : Utility.AppColor.OriginalBlue.cgColor
            cityTextField.layer.borderWidth = cityTextField.text?.count == 0 ? 2 : 3
        case moneyTextField:
            moneyTextField.layer.borderColor = moneyTextField.text?.count == 0 ? UIColor.lightGray.cgColor : Utility.AppColor.OriginalBlue.cgColor
            moneyTextField.layer.borderWidth = moneyTextField.text?.count == 0 ? 2 :3
        default:
            break
        }
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
//Mark textFieldDelegate
extension DetailSearchViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


