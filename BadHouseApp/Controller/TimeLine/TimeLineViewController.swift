import UIKit

struct VideoModel {
    let caption: String
    let userName: String
    let audioTrackName: String
    let videoFileName :String
    let videoFileFormat:String
}

class TimeLineViewController: UIViewController {
    
    private var collectionView:UICollectionView?
    private var data = [VideoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.register(VideoCell.self,forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        for _ in 0..<10 {
            let model = VideoModel(caption: "cool", userName: "mizuki", audioTrackName: "ios", videoFileName: "video", videoFileFormat: "mmp4")
            data.append(model)
        }
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
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    
}
