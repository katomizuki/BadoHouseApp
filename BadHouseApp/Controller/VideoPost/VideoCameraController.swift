import UIKit
import Photos
import AVFoundation
import FirebaseStorage
import Firebase

final class VideoCameraController: UIViewController {
    // MARK: - Properties
    var keyWord = String()
    let captureSession = AVCaptureSession()
    let fileOutput = AVCaptureMovieFileOutput()
    var recordButton: UIButton!
    var isRecording = false
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    // MARK: - SetupMethod
    private func setUpCamera() {
        // デバイスの初期化
        if UIDevice.current.userInterfaceIdiom.rawValue == 0 {
        let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)
        // ビデオの画質
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
        let videoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        fileOutput.maxRecordedDuration = CMTimeMake(value: 60, timescale: 2)
        let connection = fileOutput.connection(with: .video)
        if fileOutput.availableVideoCodecTypes.contains(.hevc) {
            fileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: connection!)
        }
        // 録画ボタン
        self.recordButton = UIButton(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 80,
                                                   height: 80))
        self.recordButton.backgroundColor = .white
        self.recordButton.layer.masksToBounds = true
        self.recordButton.layer.cornerRadius = 80 / 2
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2,
                                                   y: self.view.bounds.height - 120)
        self.recordButton.addTarget(self, action: #selector(self.tappedRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
        } else {
            self.setupCDAlert(title: "利用できる端末ではありません", message: "", action: "OK", alertType: .warning)
        }
    }
    // MARK: - SelectorMethod
    @objc private func tappedRecordButton(sender: UIButton) {
        if isRecording {
            // 録画終了
            fileOutput.stopRecording()
            self.isRecording = false
            sender.backgroundColor = .white
            self.navigationController?.popViewController(animated: true)
        } else {
            // 録画開始
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = path[0] as String
            let filePath: String = "\(documentDirectory)/.mp4"
            let fileURL: NSURL = NSURL(fileURLWithPath: filePath)
            let url = fileURL as URL
            fileOutput.startRecording(to: url, recordingDelegate: self)
            self.isRecording = true
            sender.backgroundColor = Constants.AppColor.OriginalBlue
        }
    }
}
// MARK: - AVfileoutputDelegate
extension VideoCameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        StorageService.sendVideoData(videoUrl: outputFileURL, senderId: AuthService.getUserId(), keyWord: self.keyWord)
        LocalNotificationManager.setNotification(3, of: .seconds, repeats: false, title: "プレ-を投稿しました", body: "")
    }
}
