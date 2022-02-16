import RxSwift
import RxCocoa
import FirebaseAuth
import UIKit

protocol MakeEventSecondViewModelInputs {
    var minLevel: PublishSubject<Float> { get }
    var maxLevel: PublishSubject<Float> { get }
}

protocol MakeEventSecondViewModelOutputs {
    var minLevelText: BehaviorRelay<String> { get }
    var maxLevelText: BehaviorRelay<String> { get }
    var circleRelay: BehaviorRelay<[Circle]> { get }
}

protocol MakeEventSecondViewModelType {
    var inputs: MakeEventSecondViewModelInputs { get }
    var outputs: MakeEventSecondViewModelOutputs { get }
}

final class MakeEventSecondViewModel: MakeEventSecondViewModelType, MakeEventSecondViewModelOutputs, MakeEventSecondViewModelInputs {
    
    var minLevel = PublishSubject<Float>()
    var maxLevel = PublishSubject<Float>()
    var inputs: MakeEventSecondViewModelInputs { return self }
    var outputs: MakeEventSecondViewModelOutputs { return self }
    var minLevelText = BehaviorRelay<String>(value: "レベル1")
    var maxLevelText = BehaviorRelay<String>(value: "レベル10")
    var circleRelay = BehaviorRelay<[Circle]>(value: [])
    private let userAPI: UserRepositry
    var user: User?
    var circle: Circle?
    private let disposeBag = DisposeBag()
    var title: String
    var image: UIImage
    var kind: String
    var dic: [String: Any] = [String: Any]()
    
    init(userAPI: UserRepositry, title: String, image: UIImage, kind: String) {
        self.userAPI = userAPI
        self.title = title
        self.image = image
        self.kind = kind
        self.dic["title"] = title
        self.dic["kind"] = kind
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userAPI.getMyCircles(uid: uid).subscribe { [weak self] circle in
            self?.circleRelay.accept(circle)
        }.disposed(by: disposeBag)

        UserRepositryImpl.getUserById(uid: uid) { user in
            self.user = user
        }
        
        minLevel.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            let minText = self.changeNumber(num: value)
            self.minLevelText.accept(minText)
        }).disposed(by: disposeBag)
        maxLevel.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            let maxText = self.changeNumber(num: value)
            self.maxLevelText.accept(maxText)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    func changeNumber(num: Float) -> String {
        var message = String()
        switch num * 10 {
        case 0..<1:
            message = BadmintonLevel(rawValue: 0)!.description
        case 1..<2:
            message = BadmintonLevel(rawValue: 1)!.description
        case 2..<3:
            message = BadmintonLevel(rawValue: 2)!.description
        case 3..<4:
            message = BadmintonLevel(rawValue: 3)!.description
        case 4..<5:
            message = BadmintonLevel(rawValue: 4)!.description
        case 5..<6:
            message = BadmintonLevel(rawValue: 5)!.description
        case 6..<7:
            message = BadmintonLevel(rawValue: 6)!.description
        case 7..<8:
            message = BadmintonLevel(rawValue: 7)!.description
        case 8..<9:
            message = BadmintonLevel(rawValue: 8)!.description
        case 9...10:
            message = BadmintonLevel(rawValue: 9)!.description
        default:
            break
        }
        return message
    }
}
