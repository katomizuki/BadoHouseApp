import UIKit
import Foundation
protocol SearchVideoDelegate: AnyObject {
    func getVideoData(videoArray: [VideoModel], vc: VideoPopoverController)
}
class VideoPopoverController: UIViewController {
    // MARK: - Properties
    private lazy var tv: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    private let cellId = "cellId"
    private let fetchData = FetchFirestoreData()
    weak var searchDelegate: SearchVideoDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData.videoDelegate = self
        popoverPresentationController?.backgroundColor = UIColor.white
    }
    // MARK: - setupMethod
    private func setupTableView() {
        view.addSubview(tv)
        tv.anchor(top: view.topAnchor,
                  bottom: view.bottomAnchor,
                  left: view.leftAnchor,
                  right: view.rightAnchor,
                  paddingTop: 0,
                  paddingBottom: 0,
                  paddingRight: 0,
                  paddingLeft: 0)
    }
}
// MARK: - UITableViewDataSource
extension VideoPopoverController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Badominton.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        guard let option = Badominton(rawValue: indexPath.row) else { return cell }
        let badminton = option.name
        cell.textLabel?.text = badminton
        return cell
    }
}
// MARK: - UITableViewDelegate
extension VideoPopoverController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = Badominton(rawValue: indexPath.row) else { return }
        let text = option.name
        fetchData.searchVideoData(text: text)
    }
}
// MARK: - FetchVideoDataDelegate
extension VideoPopoverController: FetchVideoDataDelegate {
    func fetchVideoData(videoArray: [VideoModel]) {
        self.searchDelegate?.getVideoData(videoArray: videoArray, vc: self)
    }
}
