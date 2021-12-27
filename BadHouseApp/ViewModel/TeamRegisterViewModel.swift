import Foundation
import RxSwift
import RxCocoa
import UIKit
// MARK: - InputProtocol
protocol TeamRegisterInput {
    var nameTextInput: AnyObserver<String> { get }
    var placeTextInput: AnyObserver<String> { get }
    var timeTextInput: AnyObserver<String> { get }
    var priceTextInput: AnyObserver<String> { get }
}
// MARK: - OutputProtocol
protocol TeamRegisterOutput {
    var nameTextOutPut: PublishSubject<String> { get }
    var placeTextOutput: PublishSubject<String> { get }
    var timeTextOutput: PublishSubject<String> { get }
    var priceTextOutput: PublishSubject<String> { get }
}
final class TeamRegisterViewModel: TeamRegisterInput, TeamRegisterOutput {
    private let disposeBag = DisposeBag()
    // MARK: - Observable
    var nameTextOutPut = PublishSubject<String>()
    var placeTextOutput = PublishSubject<String>()
    var timeTextOutput = PublishSubject<String>()
    var priceTextOutput = PublishSubject<String>()
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    var selectionsFeature = [String]()
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
    var priceTextInput: AnyObserver<String> {
        priceTextOutput.asObserver()
    }

    var validTextInput: AnyObserver<String> {
        priceTextOutput.asObserver()
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
        let levelValid = priceTextOutput
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
    func addFeatures(_ feature:CircleFeatures) {
        if judgeFeatures(feature) {
            selectionsFeature.append(feature.description)
        } else {
            selectionsFeature.remove(value: feature.description)
        }
    }
    
    func judgeFeatures(_ feature:CircleFeatures)->Bool {
        return selectionsFeature.contains(feature.description)
    }
    func buttonColor(color:UIColor?)->UIColor {
        return color == .systemBlue ? .lightGray : .systemBlue
    }
}
