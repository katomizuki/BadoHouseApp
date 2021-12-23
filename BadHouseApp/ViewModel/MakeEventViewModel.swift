import RxSwift
import UIKit
import RxRelay
import RxCocoa

protocol MakeEventFirstViewModelInputs {
    var titleTextInputs: AnyObserver<String> { get }
    var hasImage: BehaviorRelay<Bool> { get }
}
protocol MakeEventFirstViewModelOutputs {
    var titleTextOutputs: PublishSubject<String> { get }
    var isButtonValid: BehaviorRelay<Bool> { get }
    var buttonColor:UIColor { get }
    var isTitle: BehaviorRelay<Bool> { get }
    var buttonTextColor: UIColor { get }
}
protocol MakeEventFirstViewModelType {
    var inputs: MakeEventFirstViewModelInputs { get }
    var outputs: MakeEventFirstViewModelOutputs { get }
}

final class MakeEventFirstViewModel:MakeEventFirstViewModelType, MakeEventFirstViewModelInputs, MakeEventFirstViewModelOutputs {
    var buttonTextColor: UIColor {
        return isButtonValid.value ? .white : .lightGray
    }
    var isButtonValid = BehaviorRelay<Bool>(value: false)
    var hasImage = BehaviorRelay<Bool>(value: false)
    var inputs: MakeEventFirstViewModelInputs { return self }
    var outputs: MakeEventFirstViewModelOutputs { return self }
    var titleTextOutputs = PublishSubject<String>()
    var titleTextInputs: AnyObserver<String> {
        return titleTextOutputs.asObserver()
    }
    var buttonColor: UIColor {
        return isButtonValid.value ? .systemBlue : .darkGray
    }
    var isTitle = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    init() {
        let isTitleValid = titleTextOutputs.asObservable().map { text->Bool in
            return text.count >= 1
        }
        isTitleValid.subscribe(onNext: { isTitle in
            self.isTitle.accept(isTitle)
        }).disposed(by: disposeBag)


        titleTextOutputs.subscribe(onNext: { text in
            let isButtonValid = text.count >= 1
            self.isButtonValid.accept(isButtonValid)
        }).disposed(by: disposeBag)

    }
}
