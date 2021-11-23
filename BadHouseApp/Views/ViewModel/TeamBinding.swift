import Foundation
import RxSwift
import RxCocoa
// MARK: - InputProtocol
protocol TeamRegisterInput {
    var nameTextInput: AnyObserver<String> { get }
    var placeTextInput: AnyObserver<String> { get }
    var timeTextInput: AnyObserver<String> { get }
    var levelTextInput: AnyObserver<String> { get }
}
// MARK: - OutputProtocol
protocol TeamRegisterOutput {
    var nameTextOutPut: PublishSubject<String> { get }
    var placeTextOutput: PublishSubject<String> { get }
    var timeTextOutput: PublishSubject<String> { get }
    var levelTextOutput: PublishSubject<String> { get }
}
final class TeamRegisterBindings: TeamRegisterInput, TeamRegisterOutput {
    private let disposeBag = DisposeBag()
    // MARK: - Observable
    var nameTextOutPut = PublishSubject<String>()
    var placeTextOutput = PublishSubject<String>()
    var timeTextOutput = PublishSubject<String>()
    var levelTextOutput = PublishSubject<String>()
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    // MARK: - Observer
    var nameTextInput: AnyObserver<String> {
        nameTextOutPut.asObserver()
    }
    var placeTextInput: AnyObserver<String> {
        placeTextOutput.asObserver()
    }
    var timeTextInput: AnyObserver<String> {
        timeTextOutput.asObserver()
    }
    var levelTextInput: AnyObserver<String> {
        levelTextOutput.asObserver()
    }
    var validTextInput: AnyObserver<String> {
        levelTextOutput.asObserver()
    }
    var validRegisterDriver: Driver<Bool> = Driver.never()
    // MARK: - initialize
    init() {
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        let nameValid = nameTextOutPut
            .asObservable()
            .map { text -> Bool in
                return text.count >= 2
            }
        let placeValid = placeTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 2
            }
        let timeValid = timeTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 2
            }
        let levelValid = levelTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
        Observable.combineLatest(nameValid, placeValid, timeValid, levelValid) { $0 && $1 && $2 && $3 }
        .subscribe { validAll in
            self.validRegisterSubject.onNext(validAll)
        }
        .disposed(by: disposeBag)
    }
}
