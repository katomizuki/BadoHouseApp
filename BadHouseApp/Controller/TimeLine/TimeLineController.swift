import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import SkeletonView

class TimeLineController: UIViewController {
    // Mark properties
    private var collectionView:UICollectionView?
    private var data = [VideoModel]()
    private let fetchData = FetchFirestoreData()
    private var player = AVPlayer()
    private var indicator: NVActivityIndicatorView!
    // Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupIndicator()
        fetchData.fetchVideoData()
        fetchData.videoDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.isSkeletonable = true
        view.isSkeletonable = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    // Mark setupMethod
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView?.delegate = self
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
// Mark collectionViewdelegate & skeletonViewdelegate
extension TimeLineController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        let video = data[indexPath.row]
        cell.video = video
        cell.delegate = self
        return cell
    }
}
// Mark SkeletonDatasource
extension TimeLineController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return VideoCell.identifier
    }
}
// Mark getVideoDelegate
extension TimeLineController: FetchVideoDataDelegate {
    func fetchVideoData(videoArray: [VideoModel]) {
        self.data = videoArray
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}
// Mark collectionCellDelegate
extension TimeLineController: VideoCollectionCellDelegate {
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
// Mark popdelegate
extension TimeLineController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
// Mark SearchVideoDelegate
extension TimeLineController: SearchVideoDelegate {
    func getVideoData(videoArray: [VideoModel], vc: VideoPopoverController) {
        print(#function)
        vc.dismiss(animated: true, completion: nil)
        self.data = videoArray
        collectionView?.reloadData()
    }
}
