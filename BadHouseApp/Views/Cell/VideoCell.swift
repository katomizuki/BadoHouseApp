import Foundation
import UIKit
import AVFoundation

class VideoCell:UICollectionViewCell {
    
    var player: AVPlayer?
    static let identifier = "videoCell"
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    func configure(with model: VideoModel) {
        backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
