

import Foundation
import RxCocoa
import RxSwift
protocol MakeEventInputProtocol {
    var dateTextInput:AnyObserver<String> { get }
    var placeTextInput:AnyObserver<String> {
        get
    }
    var groupTextInput:AnyObserver<String> { get }
}

protocol MakeEventOutputProtocol {
    var dateTextOutput:PublishSubject<String> { get }
    var placeTextOutput:PublishSubject<String> {
        get
    }
    var groupTextOutput:PublishSubject<String> {
        get
    }
}


class MakeEventBindings:MakeEventInputProtocol,MakeEventOutputProtocol {
    
    private let disposeBag = DisposeBag()
    
    //Mark: Observable
    var dateTextOutput = PublishSubject<String>()
    var placeTextOutput = PublishSubject<String>()
    var groupTextOutput = PublishSubject<String>()
    var validMakeSubject = BehaviorSubject<Bool>(value: false)
    
    //Mark: Observer
    
    var dateTextInput:AnyObserver<String> {
        dateTextOutput.asObserver()
    }
    
    var placeTextInput:AnyObserver<String> {
        placeTextOutput.asObserver()
    }
    
    var groupTextInput:AnyObserver<String> {
        groupTextOutput.asObserver()
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
        
        let placeValid = placeTextOutput
            .asObservable()
            .map { text in
                return text.count >= 1
            }
        
        let groupValid = groupTextOutput
            .asObservable()
            .map { text in
                return text.count >= 1
            }
        
        Observable.combineLatest(dateValid, placeValid, groupValid) { $0 && $1 && $2 }
            .subscribe {validAll in
                self.validMakeSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
        
    }
    
}
