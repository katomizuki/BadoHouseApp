import RxSwift
import RxRelay

protocol SearchCircleViewModelInputs {
    var searchBarTextInput: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
}

protocol SearchCircleViewModelOutputs {
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var isError: Observable<Bool> { get }
}

protocol SearchCircleViewModelType {
    var inputs: SearchCircleViewModelInputs { get }
    var outputs: SearchCircleViewModelOutputs { get }
}

final class SearchCircleViewModel: SearchCircleViewModelType {

    var inputs: SearchCircleViewModelInputs { return self }
    var outputs: SearchCircleViewModelOutputs { return self }
    
    private let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    private let searchBarText = PublishSubject<String>()
    let circleRelay = BehaviorRelay<[Circle]>(value: [])
    let user: User
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
                self?.errorInput.onNext(true)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
extension SearchCircleViewModel: SearchCircleViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }

    var searchBarTextInput: AnyObserver<String> {
        return searchBarText.asObserver()
    }
    
}

extension SearchCircleViewModel: SearchCircleViewModelOutputs {

    var isError: Observable<Bool> {
        errorStream.asObservable()
    }

}
