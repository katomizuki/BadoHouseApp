import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import SkeletonView

class TimeLineViewController: UIViewController{
    //Mark properties
    private var collectionView:UICollectionView?
    private var data = [VideoModel]()
    private let fetchData = FetchFirestoreData()
    private var player = AVPlayer()
    private var indicator:NVActivityIndicatorView!
    //Mark lifecycle
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    //Mark setupMethod
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
    
    private func setupIndicator() {
        self.indicator = self.setupIndicatorView()
        view.addSubview(indicator)
        indicator.anchor(centerX: view.centerXAnchor,
                         centerY: view.centerYAnchor,
                         width:100,
                         height: 100)
    }
}
//Mark:collectionViewdelegate & skeletonViewdelegate
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
//Mark:getVideoDelegate
extension TimeLineViewController:GetVideoDelegate {
    func getVideo(videoArray: [VideoModel]) {
        self.data = videoArray
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}
//Mark collectionCellDelegate
extension TimeLineViewController:VideoCollectionCellDelegate ,UIPopoverPresentationControllerDelegate{
    
    func didTapSearchButton(video: VideoModel,button:UIButton) {
        print(#function)
        let vc = PopoverViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        vc.popoverPresentationController?.sourceView = button
        vc.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint.zero, size: button.bounds.size)
        vc.popoverPresentationController?.permittedArrowDirections = .down
        vc.popoverPresentationController?.delegate = self
        vc.SearchDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapNextButton(video: VideoModel) {
        print(#function)
        fetchData.getVideoData()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}
//Mark SearchVideoDelegate
extension TimeLineViewController: SearchVideoDelegate{
    
    func getVideoData(videoArray: [VideoModel]) {
        print(#function)
        self.data = videoArray
        collectionView?.reloadData()
    }
}

protocol SearchVideoDelegate:AnyObject {
    func getVideoData(videoArray:[VideoModel])
}
class PopoverViewController: UIViewController {
    //Mark properties
    private let tv:UITableView = {
        let tv = UITableView()
        return tv
    }()
    private let cellId = "cellId"
    private let kindArray = Utility.Data.badomintonArray
    private let fetchData = FetchFirestoreData()
    weak var SearchDelegate:SearchVideoDelegate?
    //Mark properties
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData.videoDelegate = self
    }
    //Mark setupMethod
    private func setupTableView() {
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        popoverPresentationController?.backgroundColor = UIColor.white
        view.addSubview(tv)
        tv.anchor(top:view.topAnchor,bottom:view.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 0,paddingBottom:0, paddingRight:0, paddingLeft: 0)
        tv.delegate = self
        tv.dataSource = self
    }
}
//Mark tableviewdelegate
extension PopoverViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kindArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = kindArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = kindArray[indexPath.row]
        fetchData.searchVideoData(text: text)
    }
}
//Mark:VideoDelegate
extension PopoverViewController:GetVideoDelegate {
    func getVideo(videoArray: [VideoModel]) {
        self.SearchDelegate?.getVideoData(videoArray: videoArray)
        dismiss(animated: true, completion: nil)
    }
}
