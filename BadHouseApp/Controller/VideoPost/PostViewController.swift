import UIKit
import Photos
import AVFoundation
import FirebaseStorage
import Firebase

class PostViewController: UIViewController {
    
    private let logoImage:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.logoImage)
        return iv
    }()
    private let singleButton = RegisterButton(text: "シングルス")
    private let doubleButton = RegisterButton(text: "ダブルス")
    private let mixButton = RegisterButton(text: "ミックス")
    private let label = ProfileLabel(title: "今日の1ラリーを投稿してみよう", num: 24)
    
        let captureSession = AVCaptureSession()
        let fileOutput = AVCaptureMovieFileOutput()
        var recordButton: UIButton!
        var isRecording = false

      override func viewDidLoad() {
          super.viewDidLoad()
          setupLayout()
      }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [label,singleButton,doubleButton,mixButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        singleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        doubleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        mixButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Utility.AppColor.OriginalBlue
        
        
        view.addSubview(stackView)
        view.addSubview(logoImage)
        stackView.anchor(top:logoImage.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor,paddingTop: 30,paddingRight:30, paddingLeft: 30,height:300)
        logoImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 70,centerX: view.centerXAnchor,width: 100,height: 100)
        
        singleButton.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
        doubleButton.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
        mixButton.addTarget(self, action: #selector(handle), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func handle(sender:UIButton) {
        #if targetEnvironment(simulator)
            // do nothing
        #else
        if sender == singleButton {
            print("single")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
            vc.keyWord = "シングルス"
            navigationController?.pushViewController(vc, animated: true)
        } else if sender == doubleButton {
            print("double")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
            vc.keyWord = "ダブルス"
            navigationController?.pushViewController(vc, animated: true)
        } else if sender == mixButton {
            print("mix")
            let vc = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraViewController
            vc.keyWord = "ミックス"
            navigationController?.pushViewController(vc, animated: true)
        }
        #endif
    }
}
