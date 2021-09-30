import Foundation
import UIKit
import AVFoundation
import SDWebImage
import SkeletonView

protocol VideoCollectionCellDelegate:AnyObject {
    func didTapSearchButton(video:VideoModel)
    func didTapNextButton(video:VideoModel)
}
class VideoCell:UICollectionViewCell {
    
    var player: AVPlayer?
    static let identifier = "videoCell"
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
        button.backgroundColor = .purple
        button.setImage(UIImage(systemName: "person.circle"), for: UIControl.State.normal)
        return button
    }()
    
    private let searchButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .cyan
        button.setImage(UIImage(systemName: "person.circle"), for: UIControl.State.normal)
        return button
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        return view
    }()
    
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
        let size = contentView.frame.size.width / 7
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 150
        searchButton.frame = CGRect(x:width - size,y:height - size ,width: size,height: size)
        nextButton.frame = CGRect(x: width - size, y: height - (size * 2) - 10, width: size, height: size)
    }
    
    weak var delegate:VideoCollectionCellDelegate?
    
    private func setupLayout() {
       
        contentView.addSubview(containerView)
        contentView.addSubview(nextButton)
        contentView.addSubview(searchButton)
        
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        containerView.clipsToBounds = true
        contentView.sendSubviewToBack(containerView)

    }
    
    
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
        self.delegate?.didTapSearchButton(video: video)
    }
    
    func configure() {
        setupLayout()
       
        guard let videoUrl = URL(string: video?.videoUrl ?? "") else { return }
        player = AVPlayer(url: videoUrl)
        let playerView = AVPlayerLayer()
        playerView.videoGravity = .resizeAspectFill
        playerView.player = player
        playerView.frame = contentView.bounds
        
        containerView.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
        containerView.stopSkeletonAnimation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
