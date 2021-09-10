

import UIKit
import TaggerKit
import Firebase

class TagViewController: UIViewController, TKCollectionViewDelegate {
    
    //Mark:Properties
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var testContainerView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    var plusTagArray = ["#バドミントン好き歓迎","#バドハウス大好き"]
    var productTags:TKCollectionView!
    var allTags:TKCollectionView!
    var dic = [String:Any]()
    var teamId = String()
    var eventId = String()
    var eventImage:UIImage?
    private var tagCollection = TKCollectionView()
    
    
    //Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.backgroundColor = Utility.AppColor.OriginalBlue
        finishButton.setTitle("イベント作成", for: UIControl.State.normal)
        finishButton.setTitleColor(.white, for: UIControl.State.normal)
        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        finishButton.layer.cornerRadius = 15
        finishButton.layer.masksToBounds = true
        
        productTags = TKCollectionView(tags: ["#バドミントン好き歓迎","#バドハウス大好き"],
                                              action: .removeTag,
                                              receiver: nil)
               
               allTags = TKCollectionView(tags: [
                "#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△"],
                                          action: .addTag,
                                          receiver: productTags)
        
        
        productTags.delegate = self
        allTags.delegate = self
        
        add(allTags,toView:  testContainerView)
        add(productTags,toView:searchContainerView)
        
        allTags.customBackgroundColor = .white
        productTags.customBackgroundColor = Utility.AppColor.OriginalLightBlue
        allTags.customTagBorderColor = .lightGray
        allTags.customTagBorderWidth = 4
    }
    
    //Mark:IBAction
    @IBAction func finishAction(_ sender: Any) {
        guard let image = eventImage else { return }
        Storage.addEventImage(image: image) { urlString in
            self.dic["urlEventString"] = urlString
            Firestore.sendEventData(teamId:self.teamId, event: self.dic, eventId: self.eventId)
            Firestore.sendTagData(eventId: self.eventId, tags: self.plusTagArray, teamId: self.teamId)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //Mark:TagMethod
    func tagIsBeingAdded(name: String?) {
        guard let text = name else { return }
        if searchTag(text: text) == nil {
            plusTagArray.append(name ?? "")
            print(dic)

        }
    }
    
    func tagIsBeingRemoved(name: String?) {
        guard let text = name else { return }
        if searchTag(text: text) != nil {
            guard let index = searchTag(text:text) else { return }
            plusTagArray.remove(at: index)
        }
    }
    
    private func searchTag(text:String)->Int? {
        for i in 0..<plusTagArray.count {
            if text == plusTagArray[i] {
                return i
            }
        }
        return nil
    }
    
}
