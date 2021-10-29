import Foundation
import UIKit
protocol backDelegate: AnyObject {
    func updateTeamData(vc: UpdateTeamController)
}
final class UpdateTeamController: UIViewController {
    // Mark properties
    var team: TeamModel?
    private let placeTextField = ProfileTextField(placeholder: "")
    private let timeTextField = ProfileTextField(placeholder: "")
    private let moneyTextField = ProfileTextField(placeholder: "")
    weak var delegate: backDelegate?
    private lazy var iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.noImages)
        iv.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        iv.layer.borderWidth = 2
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleImagePicker))
        iv.addGestureRecognizer(touchGesture)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 75
        iv.layer.masksToBounds = true
        return iv
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.updateButton(radius: 15, backColor: Constants.AppColor.OriginalBlue, titleColor: .white, fontSize: 16)
        button.setTitle("保存する", for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let imagePicker = UIImagePickerController()
    // Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupteamInfo()
        imagePicker.delegate = self
    }
    // Mark setupMethod
    private func setupLayout() {
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let stackView = UIStackView(arrangedSubviews: [placeTextField,
                                                       timeTextField,
                                                       moneyTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(iv)
        view.addSubview(button)
        view.addSubview(backButton)
        iv.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                  paddingTop: 100,
                  centerX: view.centerXAnchor,
                  width: 150,
                  height: 150)
        stackView.anchor(top: iv.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingRight: 30,
                         paddingLeft: 30,
                         height: 170)
        button.anchor(top: stackView.bottomAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      paddingTop: 20,
                      paddingRight: 30,
                      paddingLeft: 30,
                      height: 50)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
    }
    private func setupteamInfo() {
        placeTextField.text = team?.teamPlace
        timeTextField.text = team?.teamTime
        moneyTextField.text = team?.teamLevel
        guard let urlString = team?.teamImageUrl else { return }
        let url = URL(string: urlString)
        iv.sd_setImage(with: url, completed: nil)
    }
    // Mark initalize
    init(team: TeamModel) {
        super.init(nibName: nil, bundle: nil)
        self.team = team
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Mark selector
    @objc private func handleSave() {
        guard let place = placeTextField.text else { return }
        guard let time = timeTextField.text else { return }
        guard let money = moneyTextField.text else { return }
        self.team?.teamPlace = place
        self.team?.teamTime = time
        self.team?.teamLevel = money
        guard let image = iv.image else { return }
        StorageService.addTeamImage(image: image) { [weak self] urlString in
            guard let self = self else { return }
            self.team?.teamImageUrl = urlString
            guard let team = self.team else { return }
            TeamService.updateTeamData(team: team)
            self.delegate?.updateTeamData(vc: self)
        }
    }
    @objc private func handleImagePicker() {
        print(#function)
        present(imagePicker, animated: true, completion: nil)
    }
    @objc private func back() {
        self.delegate?.updateTeamData(vc: self)
    }
}
// Mark UIImagePickerDelegate
extension UpdateTeamController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        print(#function)
        iv.image = image
        dismiss(animated: true, completion: nil)
    }
}
