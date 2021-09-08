

import UIKit
import TaggerKit
import Firebase

class TagViewController: UIViewController, TKCollectionViewDelegate {
    
    
    
    
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var testContainerView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    var plusTagArray = ["#バドミントン好き歓迎","#バドハウス大好き"]
    
    var productTags:TKCollectionView!
    var allTags:TKCollectionView!
    
    var dic = [String:Any]()
    var teamId = String()
    var eventId = String()
    private var tagCollection = TKCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTags = TKCollectionView(tags: ["#バドミントン好き歓迎","#バドハウス大好き"], action: .removeTag, receiver: nil)
        allTags = TKCollectionView(tags: ["#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△","#集合時間には遅れずに","#複数人OK","#〇〇","#△△",], action: .addTag, receiver: productTags)
        
        
        productTags.delegate = self
        allTags.delegate = self
        
        
        add(productTags,toView: testContainerView)
        add(allTags,toView: searchContainerView)
        allTags.customBackgroundColor = .cyan
        productTags.customBackgroundColor = .cyan
        
        
        
    }
    
    //Mark:IBAction
    @IBAction func finishAction(_ sender: Any) {
        Firestore.sendEventData(teamId:teamId, event: dic, eventId: eventId)
        Firestore.sendTagData(eventId: eventId, tags: plusTagArray, teamId: teamId)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tagIsBeingAdded(name: String?) {
        guard let text = name else { return }
        if searchTag(text: text) == nil {
            plusTagArray.append(name ?? "")
        }
        print(plusTagArray)
    }
    
    func tagIsBeingRemoved(name: String?) {
        guard let text = name else { return }
        if searchTag(text: text) != nil {
            guard let index = searchTag(text:text) else { return }
            plusTagArray.remove(at: index)
        }
        print(plusTagArray)
        print(teamId)
        print(eventId)
        
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
