import UIKit
import RxSwift
import RxCocoa
import Firebase

final class MakeEventController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var circleSegment: UISegmentedControl! {
        didSet {
            circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
        }
    }
    @IBOutlet private weak var noImageView: UIImageView!
    @IBOutlet private weak var notTitleLabel: UILabel!
    private let fetchData = FetchFirestoreData()
    private let eventBinding = MakeEventViewModel()
    private let disposeBag = DisposeBag()
    private var selectedTeam: TeamModel?
    private var eventTitle = String()
    private var kindCircle = BadmintonCircle(rawValue: 0)?.name
    private var team: TeamModel?
    // MARK: - LifeCycle
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
    // MARK: - SetupMethod
    private func setupDelegate() {
        titleTextField.delegate = self
    }

    private func setupBinding() {
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
        notTitleLabel.isHidden = titleTextField.text?.isEmpty == true ? false : true
    }
    // MARK: IBAction
    @IBAction private func plusImage(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
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

// MARK: - textFieldDelegate
extension MakeEventController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
