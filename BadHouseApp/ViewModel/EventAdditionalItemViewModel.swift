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
    private let practiceAPI: PracticeRepositry
    private let disposeBag = DisposeBag()
    
    init(image: UIImage,
         circle: Circle,
         user: User,
         dic: [String: Any],
         practiceAPI: PracticeRepositry) {
        self.image = image
        self.circle = circle
        self.user = user
        self.dic = dic
        self.practiceAPI = practiceAPI
    }
    // ここら辺書き換えたい
    func postPractice() {
        StorageService.downLoadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urlString):
                self.dic["urlString"] = urlString
                self.dic["explain"] = self.textViewInputs
                self.practiceAPI.postPractice(dic: self.dic,
                                            circle: self.circle,
                                            user: self.user)
                    .subscribe(onCompleted: {
                        self.completed.onNext(())
                    }, onError: { _ in
                        self.isError.onNext(true)
                    }).disposed(by: self.disposeBag)
            case .failure:
                self.isError.onNext(true)
            }
        }
    }
}
