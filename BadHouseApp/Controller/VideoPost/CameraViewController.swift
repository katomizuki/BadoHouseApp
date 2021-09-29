import UIKit
import Photos
import AVFoundation
import FirebaseStorage
import Firebase

class CameraViewController: UIViewController {
    
    var keyWord = String()
    let captureSession = AVCaptureSession()
    let fileOutput = AVCaptureMovieFileOutput()
    var recordButton: UIButton!
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    // デバイスの設定
      private func setUpCamera() {
          // デバイスの初期化
          let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
          let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

          //ビデオの画質
          captureSession.sessionPreset = AVCaptureSession.Preset.medium

          // ビデオのインプット設定
          let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
          captureSession.addInput(videoInput)

          // 音声のインプット設定
          let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
          captureSession.addInput(audioInput)
          captureSession.addOutput(fileOutput)
          captureSession.startRunning()

          // ビデオ表示
          let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
          videoLayer.frame = self.view.bounds
          videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
          self.view.layer.addSublayer(videoLayer)
//          fileOutput.maxRecordedDuration = CMTimeMake(value: 2, timescale: 60)

          // 録画ボタン
          self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
          self.recordButton.backgroundColor = .white
          self.recordButton.layer.masksToBounds = true
          self.recordButton.layer.cornerRadius = 80 / 2
          self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 120)
          self.recordButton.addTarget(self, action: #selector(self.tappedRecordButton(sender:)), for: .touchUpInside)
          self.view.addSubview(recordButton)
      }

      @objc func tappedRecordButton(sender: UIButton) {

          if isRecording {
              // 録画終了
              print("終了するよん","🌀")
              fileOutput.stopRecording()
              self.isRecording = false
              sender.backgroundColor = .white
              self.navigationController?.popViewController(animated: true)
          } else {
              // 録画開始
              let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
              let documentDirectory = path[0] as String
              let filePath:String = "\(documentDirectory)/.mp4"
              let fileURL:NSURL = NSURL(fileURLWithPath: filePath)
              fileOutput.startRecording(to: fileURL as URL, recordingDelegate: self)
              self.isRecording = true
              sender.backgroundColor = Utility.AppColor.OriginalBlue
          }
      }
  }

  extension CameraViewController: AVCaptureFileOutputRecordingDelegate {

      func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
          let asset = AVURLAsset (url: outputFileURL)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
          imageGenerator.appliesPreferredTrackTransform = true
          do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
              guard let imageData = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.3) else { return }
                let videoImageThumnailImage = Storage.storage().reference().child("Thumnail").child(UUID().uuidString)
              videoImageThumnailImage.putData(imageData, metadata: nil) { metadata, error in
                  if let error = error {
                      print(error)
                      return
                  }
                  videoImageThumnailImage.downloadURL { url, error in
                      if let error = error {
                          print(error)
                          return
                      }
                      guard let thumnaiUrlString = url?.absoluteString else { return }
                      Storage.sendVideoData(videoUrl: outputFileURL, senderId: Auth.getUserId(), thumnail: thumnaiUrlString,keyWord:self.keyWord)
                  }
              }
          } catch {
              print(error)
          }
      }
  }

