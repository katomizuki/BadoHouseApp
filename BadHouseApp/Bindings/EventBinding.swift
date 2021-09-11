

import Foundation
import RxCocoa
import RxSwift

protocol MakeEventInputProtocol {
    var dateTextInput:AnyObserver<String> { get }
    var groupTextInput:AnyObserver<String> { get }
    var startTextInput:AnyObserver<String> { get }
    var finishTextInput:AnyObserver<String> { get }
    var titleTextInput:AnyObserver<String> { get }
    var moneyTextInput:AnyObserver<String> { get }
}

protocol MakeEventOutputProtocol {
    var dateTextOutput:PublishSubject<String> { get }
    var groupTextOutput:PublishSubject<String> { get }
    var startTextOutput:PublishSubject<String> { get }
    var finishTextOutput:PublishSubject<String> { get }
    var titleTextOutput:PublishSubject<String> { get }
    var moneyTextOutput:PublishSubject<String> { get }
}


class MakeEventBindings:MakeEventInputProtocol,MakeEventOutputProtocol {
    
    private let disposeBag = DisposeBag()
    
    //Mark: Observable
    var dateTextOutput = PublishSubject<String>()
    var groupTextOutput = PublishSubject<String>()
    var titleTextOutput = PublishSubject<String>()
    var finishTextOutput = PublishSubject<String>()
    var startTextOutput = PublishSubject<String>()
    var moneyTextOutput = PublishSubject<String>()
    var validMakeSubject = BehaviorSubject<Bool>(value: false)
    
    //Mark: Observer
    var dateTextInput:AnyObserver<String> {
        dateTextOutput.asObserver()
    }

    var groupTextInput:AnyObserver<String> {
        groupTextOutput.asObserver()
    }
    var titleTextInput:AnyObserver<String> {
        titleTextOutput.asObserver()
    }
    var startTextInput:AnyObserver<String> {
        startTextOutput.asObserver()
    }
    var finishTextInput:AnyObserver<String> {
        finishTextOutput.asObserver()
    }
    var moneyTextInput:AnyObserver<String> {
        moneyTextOutput.asObserver()
    }
    
    var valideMakeDriver:Driver<Bool> = Driver.never()
    
    //Mark:initialize
    init() {
        valideMakeDriver = validMakeSubject.asDriver(onErrorDriveWith: Driver.empty())
        
        let dateValid = dateTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
        
        
        let groupValid = groupTextOutput
            .asObservable()
            .map { text in
                return text.count >= 1
            }
        let startValid = startTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 1
            }
        let finishValid = finishTextOutput
            .asObservable()
            .map { text ->Bool in
                return text.count >= 1
            }
        
        let moneyValid = moneyTextOutput
            .asObservable()
            .map { text ->Bool in
                return text.count >= 1
            }
        
        let titleValid = titleTextOutput
            .asObservable()
            .map { text ->Bool in
                return text.count >= 1
            }
        
        
        
        Observable.combineLatest(dateValid, groupValid,startValid,finishValid,moneyValid,titleValid) { $0 && $1 && $2 && $3 && $4 && $5 }
            .subscribe {validAll in
                self.validMakeSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
        
    }
    
}
