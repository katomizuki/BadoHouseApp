import UIKit
import RxSwift
import RxRelay

final class EventAdditionalItemViewModel {
    let image: UIImage
    let circle: Circle
    let user: User
    var dic: [String: Any]
    var isError = PublishSubject<Bool>()
    var completed = PublishSubject<Void>()
    var textViewInputs = String()
    let practiceAPI: PracticeServieProtocol
    private let disposeBag = DisposeBag()
    
    init(image: UIImage, circle: Circle, user: User, dic: [String: Any], practiceAPI: PracticeServieProtocol) {
        self.image = image
        self.circle = circle
        self.user = user
        self.dic = dic
        self.practiceAPI = practiceAPI
    }
    
    func postPractice() {
        StorageService.downLoadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urlString):
                self.dic["urlString"] = urlString
                self.dic["explain"] = self.textViewInputs
                self.practiceAPI.postPractice(dic: self.dic,
                                            circle: self.circle,
                                            user: self.user) { error in
                    if error != nil {
                        self.isError.onNext(true)
                    }
                    self.completed.onNext(())
                }
            case .failure:
                self.isError.onNext(true)
            }
        }
    }
}
