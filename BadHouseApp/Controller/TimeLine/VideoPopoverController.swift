import UIKit
import Foundation
protocol SearchVideoDelegate:AnyObject {
    func getVideoData(videoArray:[VideoModel],vc:VideoPopoverController)
}
class VideoPopoverController: UIViewController {
    //Mark properties
    private lazy var tv:UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    private let cellId = "cellId"
    private let kindArray = Constants.Data.badomintonArray
    private let fetchData = FetchFirestoreData()
    weak var SearchDelegate:SearchVideoDelegate?
    //Mark properties
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData.videoDelegate = self
        popoverPresentationController?.backgroundColor = UIColor.white
    }
    //Mark setupMethod
    private func setupTableView() {
        view.addSubview(tv)
        tv.anchor(top:view.topAnchor,bottom:view.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 0,paddingBottom:0, paddingRight:0, paddingLeft: 0)
    }
}
//Mark tableviewdatasource
extension VideoPopoverController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kindArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = kindArray[indexPath.row]
        return cell
    }
}
//Extension UITableViewDelegate
extension VideoPopoverController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = kindArray[indexPath.row]
        fetchData.searchVideoData(text: text)
    }
}
//Mark:VideoDelegate
extension VideoPopoverController:FetchVideoDataDelegate {
    func fetchVideoData(videoArray: [VideoModel]) {
        self.SearchDelegate?.getVideoData(videoArray: videoArray,vc:self)
    }
}
