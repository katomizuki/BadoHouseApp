import UIKit
import Photos
import AVFoundation
import FirebaseStorage
import Firebase

class PostVideoController: UIViewController {
    // Mark Properties
    private let logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
        return iv
    }()
    private lazy var singleButton: UIButton = {
        let button = RegisterButton(text: Badominton.single.rawValue)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var doubleButton: UIButton = {
        let button = RegisterButton(text: Badominton.double.rawValue)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var mixButton: UIButton = {
        let button = RegisterButton(text: Badominton.mix.rawValue)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let label: UILabel = {
        let label = ProfileLabel(title: "今日の1ラリーを投稿してみよう", num: 20)
        label.textColor = Constants.AppColor.OriginalBlue
        return label
    }()
    let captureSession = AVCaptureSession()
    let fileOutput = AVCaptureMovieFileOutput()
    var recordButton: UIButton!
    var isRecording = false
    // Mark lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    // Mark setupMethod
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [label, singleButton, doubleButton, mixButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(logoImage)
        stackView.anchor(top: logoImage.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 30,
                         paddingRight: 30,
                         paddingLeft: 30,
                         height: 300)
        logoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 70,
                         centerX: view.centerXAnchor,
                         width: 100,
                         height: 100)
    }
    // Mark selector
    @objc private func handle(sender: UIButton) {
#if targetEnvironment(simulator)
        // do nothing
#else
        if sender == singleButton {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.CameraVC) as! CameraViewController
            vc.keyWord = Badominton.single.rawValue
            navigationController?.pushViewController(vc, animated: true)
        } else if sender == doubleButton {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.CameraVC) as! CameraViewController
            vc.keyWord = Badominton.double.rawValue
            navigationController?.pushViewController(vc, animated: true)
        } else if sender == mixButton {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.CameraVC) as! CameraViewController
            vc.keyWord = Badominton.mix.rawValue
            navigationController?.pushViewController(vc, animated: true)
        }
#endif
    }
}
