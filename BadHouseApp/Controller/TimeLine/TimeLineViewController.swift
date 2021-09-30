import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import SkeletonView


class TimeLineViewController: UIViewController{
    
    private var collectionView:UICollectionView?
    private var data = [VideoModel]()
    private let fetchData = FetchFirestoreData()
    private var player = AVPlayer()
    private var indicator:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupIndicator()
        fetchData.getVideoData()
        fetchData.videoDelegate = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.isSkeletonable = true
        view.isSkeletonable = true
    }
    
   
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height)
        
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.register(VideoCell.self,forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        collectionView?.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 0,paddingBottom: 0,paddingRight: 0,paddingLeft: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setupIndicator() {
        self.indicator = self.setupIndicatorView()
        view.addSubview(indicator)
        indicator.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
}
extension TimeLineViewController:UICollectionViewDelegate,UICollectionViewDataSource,SkeletonCollectionViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return VideoCell.identifier
    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

extension TimeLineViewController:GetVideoDelegate {
    func getVideo(videoArray: [VideoModel]) {
        self.data = videoArray
        collectionView?.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.indicator.stopAnimating()
//            self.collectionView?.stopSkeletonAnimation()
//        }

    }
}

extension TimeLineViewController:VideoCollectionCellDelegate {
    
    func didTapSearchButton(video: VideoModel) {
        print(#function)
    }
    
    func didTapNextButton(video: VideoModel) {
        print(#function)
    }
    
    
}
