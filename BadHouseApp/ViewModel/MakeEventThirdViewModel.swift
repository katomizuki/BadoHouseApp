import RxSwift
import Firebase
import UIKit
import Domain

protocol MakeEventThirdViewModelInputs {
    func changedStartPicker(_ date: Date)
    func changedDeadLinePicker(_ date: Date)
    func changedFinishPicker(_ date: Date)
    func changedCourtCount(_ count: Int)
    func changedGatherCount(_ count: Int)
    func changedMoney(_ priceText: String)
    func placeInfo(_ placeName: String,
                   _ addressName: String,
                   _ latitude: Double,
                   _ longitude: Double)
}

protocol MakeEventThirdViewModelOutputs {
    
}

protocol MakeEventThirdViewModelType {
    var inputs: MakeEventThirdViewModelInputs { get }
    var outputs: MakeEventThirdViewModelOutputs { get }
}

final class MakeEventThirdViewModel: MakeEventThirdViewModelInputs, MakeEventThirdViewModelOutputs, MakeEventThirdViewModelType {
    
    var inputs: any MakeEventThirdViewModelInputs { self }
    var outputs: any MakeEventThirdViewModelOutputs { self }
    
    var image: UIImage
    var dic: [String: Any]
    var circle: Domain.CircleModel
    var user: Domain.UserModel
    
    init(image: UIImage,
         dic: [String: Any],
         circle: Domain.CircleModel,
         user: Domain.UserModel) {
        self.image = image
        self.dic = dic
        self.circle = circle
        self.user = user
    }
    
    func changedStartPicker(_ date: Date) {
        dic["start"] = Timestamp(date: date)
    }
    
    func changedDeadLinePicker(_ date: Date) {
        dic["deadLine"] = Timestamp(date: date)
    }
    
    func changedFinishPicker(_ date: Date) {
        dic["finish"] = Timestamp(date: date)
    }
    
    func changedCourtCount(_ count: Int) {
        dic["court"] = count
    }
    
    func changedGatherCount(_ count: Int) {
        dic["gather"] = count
    }
    
    func changedMoney(_ priceText: String) {
        dic["money"] = priceText
    }
    
    func placeInfo(_ placeName: String, _ addressName: String, _ latitude: Double, _ longitude: Double) {
        dic["placeName"] = placeName
        dic["addressName"] = addressName
        dic["latitude"] = latitude
        dic["longitude"] = longitude
    }
}
