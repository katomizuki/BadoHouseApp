import Foundation
import UIKit
import AVFoundation
import SDWebImage
import SkeletonView

protocol VideoCollectionCellDelegate:AnyObject {
    func didTapSearchButton(video:VideoModel,button:UIButton)
    func didTapNextButton(video:VideoModel)
}
class VideoCell:UICollectionViewCell {
    
    //Mark properties
    var player: AVPlayer?
    static let identifier = Constants.CellId.videoCell
    var iv:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .cyan
        return iv
    }()
    
    var video:VideoModel? {
        didSet {
            configure()
        }
    }
    private let nextButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.reload), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        return button
    }()
    
    private let searchButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:Constants.ImageName.search), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        return button
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        return view
    }()
    weak var delegate:VideoCollectionCellDelegate?
    
    //Mark initialize
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        player?.automaticallyWaitsToMinimizeStalling = true
        self.contentView.isSkeletonable = true
        self.containerView.isSkeletonable = true
        self.nextButton.isSkeletonable = true
        self.searchButton.isSkeletonable = true
        isSkeletonable = true
        containerView.showAnimatedSkeleton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = contentView.bounds
        let size = contentView.frame.size.width / 6
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 80
        searchButton.frame = CGRect(x:width - size,y:height - size ,width: size,height: size)
        nextButton.frame = CGRect(x: width - size, y: height - (size * 2) - 10, width: size, height: size)
    }
    //Mark setupMethod
    private func setupLayout() {
        contentView.addSubview(containerView)
        contentView.addSubview(nextButton)
        contentView.addSubview(searchButton)
        
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        containerView.clipsToBounds = true
        contentView.sendSubviewToBack(containerView)
    }
    //Mark selector
    @objc private func handleNext() {
        print(#function)
        guard let video = video else {
            return
        }
        self.delegate?.didTapNextButton(video: video)
    }
    
    @objc private func handleSearch() {
        print(#function)
        guard let video = video else {
            return
        }
        self.delegate?.didTapSearchButton(video: video,button: searchButton)
    }
    //Mark helperMethod
    func configure() {
        setupLayout()
        guard let videoUrl = URL(string: video?.videoUrl ?? "") else { return }
        player = AVPlayer(url: videoUrl)
        let playerView = AVPlayerLayer()
        playerView.videoGravity = .resizeAspectFill
        playerView.player = player
        playerView.frame = contentView.bounds
        containerView.layer.addSublayer(playerView)
        player?.play()
        containerView.stopSkeletonAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
