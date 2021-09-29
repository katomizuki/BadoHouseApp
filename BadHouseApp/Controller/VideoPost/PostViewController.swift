import UIKit
import Photos
import AVFoundation
import FirebaseStorage
import Firebase

class PostViewController: UIViewController {
    
    private let singleButton = RegisterButton(text: "シングルス")
    private let doubleButton = RegisterButton(text: "ダブルス")
    private let mixButton = RegisterButton(text: "ミックス")
    
        let captureSession = AVCaptureSession()
        let fileOutput = AVCaptureMovieFileOutput()
        var recordButton: UIButton!
        var isRecording = false

      override func viewDidLoad() {
          super.viewDidLoad()
          
          let stackView = UIStackView(arrangedSubviews: [singleButton,doubleButton,mixButton])
          stackView.axis = .vertical
          stackView.spacing = 20
          stackView.distribution = .fillEqually
          
          view.addSubview(stackView)
          stackView.anchor(left:view.leftAnchor,right: view.rightAnchor,paddingRight:30, paddingLeft: 30,centerY:view.centerYAnchor ,height:200)
          
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
