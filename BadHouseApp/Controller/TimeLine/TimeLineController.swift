import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView


class TimeLineController: UIViewController {
    // MARK: - Properties
    private var collectionView: UICollectionView?
    private var videoArray = [VideoModel]()
    private let fetchData = FetchFirestoreData()
    private var player = AVPlayer()
    private var indicator: NVActivityIndicatorView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupIndicator()
        fetchData.fetchVideoData()
        fetchData.videoDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
//        collectionView?.isSkeletonable = true
//        view.isSkeletonable = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    // MARK: - setupMethod
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.id)
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        collectionView?.anchor(top: view.topAnchor,
                               bottom: view.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               paddingTop: 0,
                               paddingBottom: 0,
                               paddingRight: 0,
                               paddingLeft: 0)
    }
    private func setupIndicator() {
        self.indicator = self.setupIndicatorView()
        view.addSubview(indicator)
        indicator.anchor(centerX: view.centerXAnchor,
                         centerY: view.centerYAnchor,
                         width: 100,
                         height: 100)
    }
}
// MARK: - collectionViewdelegate
extension TimeLineController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.id, for: indexPath) as! VideoCell
        let video = videoArray[indexPath.row]
        cell.video = video
        cell.delegate = self
        return cell
    }
}
//// MARK: - SkeletonCollectionViewDataSource
//extension TimeLineController: SkeletonCollectionViewDataSource {
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return VideoCell.id
//    }
//}
// MARK: - FetchVideoDataDelegate
extension TimeLineController: FetchVideoDataDelegate {
    func fetchVideoData(videoArray: [VideoModel]) {
        self.videoArray = videoArray
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}
// MARK: - VideoCollectionCellDelegate
extension TimeLineController: VideoCollectionCellDelegate {
    func didTapDeleteButton(_ cell: VideoCell) {
        let indexPath = collectionView?.indexPath(for: cell)
        guard let index = indexPath?[1] else { return }
        let videoId = videoArray[index].videoId
        let alertVC = UIAlertController(title: "不正なコンテンツであれば通報してください。", message: "", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "通報する", style: .default) { _ in
            BlockService.sendVideoBlockContent(videoId: videoId) { result in
                switch result {
                case .success:
                    self.videoArray.remove(at: index)
                    self.collectionView?.reloadData()
                case .failure(let error):
                    let message = self.setupFirestoreErrorMessage(error: error as! NSError)
                    self.setupCDAlert(title: "通報に失敗しました", message: message, action: "OK", alertType: .warning)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
    }
    func didTapSearchButton(video: VideoModel, button: UIButton) {
        print(#function)
        let vc = VideoPopoverController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        vc.popoverPresentationController?.sourceView = button
        vc.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint.zero,
                                                              size: button.bounds.size)
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.popoverPresentationController?.delegate = self
        vc.searchDelegate = self
        present(vc, animated: true, completion: nil)
    }
    func didTapNextButton(video: VideoModel) {
        print(#function)
        fetchData.fetchVideoData()
    }
}
// MARK: - UIPopoverPresentationControllerDelegate
extension TimeLineController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
// MARK: - SearchVideoDelegate
extension TimeLineController: SearchVideoDelegate {
    func getVideoData(videoArray: [VideoModel], vc: VideoPopoverController) {
        print(#function)
        vc.dismiss(animated: true, completion: nil)
        self.videoArray = videoArray
        collectionView?.reloadData()
    }
}
