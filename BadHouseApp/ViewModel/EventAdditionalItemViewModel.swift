import UIKit
import RxSwift
import RxRelay
import ReSwift

final class EventAdditionalItemViewModel {
    
    var dic: [String: Any]
    var textViewInputs = String()

    let isError = PublishSubject<Bool>()
    let completed = PublishSubject<Void>()
    let image: UIImage
    let circle: Circle
    let user: User

    private let practiceAPI: PracticeRepositry
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: EventAdditionlItemsActionCreator
    
    init(image: UIImage,
         circle: Circle,
         user: User,
         dic: [String: Any],
         practiceAPI: PracticeRepositry,
         store: Store<AppState>,
         actionCreator: EventAdditionlItemsActionCreator) {
        self.image = image
        self.circle = circle
        self.user = user
        self.dic = dic
        self.practiceAPI = practiceAPI
        self.store = store
        self.actionCreator = actionCreator
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
