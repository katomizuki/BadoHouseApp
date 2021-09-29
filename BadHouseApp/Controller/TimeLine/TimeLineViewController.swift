import UIKit
import AVFoundation
import AVKit


class TimeLineViewController: UIViewController {
    
    private var collectionView:UICollectionView?
    private var data = [VideoModel]()
    private let fetchData = FetchFirestoreData()
    private var playerVC = AVPlayerViewController()
    private var player = AVPlayer()
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData.getVideoData()
        fetchData.videoDelegate = self
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
        collectionView?.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 10,paddingBottom: 0,paddingRight: 0,paddingLeft: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
}
extension TimeLineViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
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
