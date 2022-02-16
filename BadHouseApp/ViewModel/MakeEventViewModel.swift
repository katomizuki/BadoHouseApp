import RxSwift
import UIKit
import RxRelay
import RxCocoa

protocol MakeEventFirstViewModelInputs {
    var titleTextInputs: AnyObserver<String> { get }
    var hasImage: BehaviorRelay<Bool> { get }
}

protocol MakeEventFirstViewModelOutputs {
    var titleTextOutputs: Observable<String> { get }
    var isButtonValid: BehaviorRelay<Bool> { get }
    var buttonColor: UIColor { get }
    var isTitle: BehaviorRelay<Bool> { get }
    var buttonTextColor: UIColor { get }
}

protocol MakeEventFirstViewModelType {
    var inputs: MakeEventFirstViewModelInputs { get }
    var outputs: MakeEventFirstViewModelOutputs { get }
}

final class MakeEventFirstViewModel: MakeEventFirstViewModelType, MakeEventFirstViewModelInputs, MakeEventFirstViewModelOutputs {
    
    var buttonTextColor: UIColor {
        return isButtonValid.value ? .white : .lightGray
    }
    
    var isButtonValid = BehaviorRelay<Bool>(value: false)
    var hasImage = BehaviorRelay<Bool>(value: false)
    var inputs: MakeEventFirstViewModelInputs { return self }
    var outputs: MakeEventFirstViewModelOutputs { return self }
    
    private let titleTextStream = PublishSubject<String>()
    
    var titleTextInputs: AnyObserver<String> {
        return titleTextStream.asObserver()
    }
    
    var titleTextOutputs: Observable<String> {
        return titleTextStream.asObservable()
    }
    
    var buttonColor: UIColor {
        return isButtonValid.value ? .systemBlue : .darkGray
    }
    var isTitle = BehaviorRelay<Bool>(value: false)
    var title: String?
    var practiceImage: UIImage = UIImage(named: R.image.noImages.name)!
    var practiceKind: String = BadmintonCircle(rawValue: 0)!.name
    private let disposeBag = DisposeBag()
    
    init() {
        let isTitleValid = titleTextOutputs.asObservable().map { text->Bool in
            return text.count >= 1
        }
        isTitleValid.subscribe(onNext: { isTitle in
            self.isTitle.accept(isTitle)
        }).disposed(by: disposeBag)
        
        titleTextOutputs.subscribe(onNext: { text in
            self.title = text
            let isButtonValid = text.count >= 1
            self.isButtonValid.accept(isButtonValid)
        }).disposed(by: disposeBag)

    }
}
