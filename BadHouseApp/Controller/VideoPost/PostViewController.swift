import UIKit
//import Photos
//import AVFoundation

class PostViewController: UIViewController {
    
 

      override func viewDidLoad() {
          super.viewDidLoad()
          self.view.backgroundColor = .blue
          
      }

      // デバイスの設定
//      private func setUpCamera() {
//
//          // デバイスの初期化
//          let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
//          let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)
//
//          //ビデオの画質
//          captureSession.sessionPreset = AVCaptureSession.Preset.high
//
//          // ビデオのインプット設定
//          let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
//          captureSession.addInput(videoInput)
//
//          // 音声のインプット設定
//          let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
//          captureSession.addInput(audioInput)
//          captureSession.addOutput(fileOutput)
//          captureSession.startRunning()
//
//          // ビデオ表示
//          let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//          videoLayer.frame = self.view.bounds
//          videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//          self.view.layer.addSublayer(videoLayer)
//
//          // 録画ボタン
//          self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//          self.recordButton.backgroundColor = .white
//          self.recordButton.layer.masksToBounds = true
//          self.recordButton.layer.cornerRadius = 80 / 2
//          self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 120)
//          self.recordButton.addTarget(self, action: #selector(self.tappedRecordButton(sender:)), for: .touchUpInside)
//          self.view.addSubview(recordButton)
//      }

//      @objc func tappedRecordButton(sender: UIButton) {
//
//          if self.fileOutput.isRecording {
//              // 録画終了
//              fileOutput.stopRecording()
//
//              self.recordButton.backgroundColor = .white
//          } else {
//              // 録画開始
//              let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
//              let fileURL: URL = tempDirectory.appendingPathComponent("sampletemp")
//              fileOutput.startRecording(to: fileURL, recordingDelegate: self)
//
//              self.recordButton.backgroundColor = .red
//          }
//      }
  }

//  extension PostViewController: AVCaptureFileOutputRecordingDelegate {
//
//      func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//
//          //動画をシェア
//          let activityItems = [outputFileURL as Any, "#SampleVideo"] as [Any]
//          let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//
//          activityController.popoverPresentationController?.sourceView = self.view
//          activityController.popoverPresentationController?.sourceRect = self.view.frame
//          self.present(activityController, animated: true, completion: nil)
//      }
//  }
