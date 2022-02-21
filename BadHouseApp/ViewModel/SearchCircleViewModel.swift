import RxSwift
import RxRelay

protocol SearchCircleViewModelInputs {
    var searchBarTextInput: AnyObserver<String> { get }
}

protocol SearchCircleViewModelOutputs {
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var isError: PublishSubject<Bool> { get }
}

protocol SearchCircleViewModelType {
    var inputs: SearchCircleViewModelInputs { get }
    var outputs: SearchCircleViewModelOutputs { get }
}

final class SearchCircleViewModel: SearchCircleViewModelInputs, SearchCircleViewModelOutputs, SearchCircleViewModelType {
    var inputs: SearchCircleViewModelInputs { return self }
    var outputs: SearchCircleViewModelOutputs { return self }
    
    private let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    var isError = PublishSubject<Bool>()
    private var searchBarText = PublishSubject<String>()
    var circleRelay = BehaviorRelay<[Circle]>(value: [])
    var searchBarTextInput: AnyObserver<String> {
        return searchBarText.asObserver()
    }
    var user: User
    private let errorStream = PublishSubject<Bool>()
    
    init(circleAPI: CircleRepositry, user: User) {
        self.circleAPI = circleAPI
        self.user = user
        searchBarText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            circleAPI.searchCircles(text: text).subscribe { [weak self] circles in
                guard let self = self else { return }
                self.circleRelay.accept(circles)
            } onFailure: { [weak self] _ in
                self?.isError.onNext(true)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
