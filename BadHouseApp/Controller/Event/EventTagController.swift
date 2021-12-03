//import UIKit
//import TaggerKit
//import Firebase
//
//final class EventTagController: UIViewController {
//    // MARK: - Properties
//    @IBOutlet private weak var searchContainerView: UIView!
//    @IBOutlet private weak var testContainerView: UIView!
//    @IBOutlet private weak var finishButton: UIButton! {
//        didSet {
//            finishButton.updateUI(title: "イベント作成")
//        }
//    }
//    private var plusTagArray = [String]()
//    private var productTags: TKCollectionView! {
//        didSet {
//            productTags.customBackgroundColor = Constants.AppColor.OriginalBlue
//        }
//    }
//    private var allTags: TKCollectionView! {
//        didSet {
//            allTags.customBackgroundColor = .white
//            allTags.customTagBorderColor = .lightGray
//            allTags.customTagBorderWidth = 4
//        }
//    }
//    var dic = [String: Any]()
//    var (teamId, eventId) = (String(), String())
//    var eventImage: UIImage?
//    private var tagCollection = TKCollectionView()
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTag()
//    }
//    // MARK: - setupMethod
//    private func setupTag() {
//        productTags = TKCollectionView(tags: ["#バド好き歓迎"], action: .removeTag, receiver: nil)
//        allTags = TKCollectionView(tags: Constants.Data.tagArray, action: .addTag, receiver: productTags)
//        productTags.delegate = self
//        allTags.delegate = self
//        add(allTags, toView: testContainerView)
//        add(productTags, toView: searchContainerView)
//    }
//    // MARK: - IBAction

//    // MARK: - helperMethod
//    private func searchTag(text: String) -> Int? {
//        for i in 0..<plusTagArray.count where text == plusTagArray[i] {
//                return i
//        }
//        return nil
//    }
//}
//// MARK: - TKCollectionViewDelegate
//extension EventTagController: TKCollectionViewDelegate {
//    func tagIsBeingAdded(name: String?) {
//        guard let text = name else { return }
//        if searchTag(text: text) == nil {
//            plusTagArray.append(name ?? "")
//        }
//    }
//    func tagIsBeingRemoved(name: String?) {
//        guard let text = name else { return }
//        if searchTag(text: text) != nil {
//            guard let index = searchTag(text: text) else { return }
//            plusTagArray.remove(at: index)
//        }
//    }
//}
