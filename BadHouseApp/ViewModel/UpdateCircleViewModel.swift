import RxSwift
import RxRelay
import UIKit

protocol UpdateCircleViewModelInputs {
    var nameTextInputs: AnyObserver<String> { get }
    var priceTextInputs: AnyObserver<String> { get }
    var placeTextInputs: AnyObserver<String> { get }
    var dateTextInput: AnyObserver<String> { get }
    var textViewInputs: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
    var completedInput: AnyObserver<Void> { get }
    func save()
}

protocol UpdateCircleViewModelOutputs {
    var isError: Observable<Bool> { get }
    var completed: Observable<Void> { get }
}

protocol UpdateCircleViewModelType {
    var inputs: UpdateCircleViewModelInputs { get }
    var outputs: UpdateCircleViewModelOutputs { get }
}

final class UpdateCircleViewModel: UpdateCircleViewModelType {
    
    var inputs: UpdateCircleViewModelInputs { return self }
    var outputs: UpdateCircleViewModelOutputs { return self }
    let circleAPI: CircleRepositry
    var circle: Circle
    
    private let nameTextSubject = PublishSubject<String>()
    private let priceTextSubject = PublishSubject<String>()
    private let placeTextSubject = PublishSubject<String>()
    private let dateTextSubject = PublishSubject<String>()
    private let textViewSubject = PublishSubject<String>()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    var iconImage: UIImage?
    var backgroundImage: UIImage?
    lazy var selectionsFeature = circle.features
    
    init(circleAPI: CircleRepositry, circle: Circle) {
        self.circle = circle
        self.circleAPI = circleAPI
        
        nameTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.name = text
        }).disposed(by: disposeBag)
        
        placeTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.place = text
        }).disposed(by: disposeBag)
        
        priceTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.price = text
        }).disposed(by: disposeBag)
        
        dateTextSubject.subscribe(onNext: { [weak self] text in
            self?.circle.time = text
        }).disposed(by: disposeBag)
        
        textViewSubject.subscribe(onNext: { [weak self] text in
            self?.circle.additionlText = text
        }).disposed(by: disposeBag)
    }
    
    func save() {
        if iconImage != nil && backgroundImage != nil {
            StorageService.downLoadImage(image: iconImage!) { result in
                switch result {
                case .success(let iconUrlString):
                    self.circle.icon = iconUrlString
                    StorageService.downLoadImage(image: self.backgroundImage!) { result in
                        switch result {
                        case .success(let backGroundUrl):
                            self.circle.backGround = backGroundUrl
                            self.saveCircleAction(self.circle)
                        case .failure:
                            self.errorInput.onNext(true)
                        }
                    }
                case .failure:
                    self.errorInput.onNext(true)
                }
            }
        } else if iconImage == nil && backgroundImage == nil {
            self.saveCircleAction(circle)
        } else if iconImage != nil {
            StorageService.downLoadImage(image: iconImage!) { result in
                switch result {
                case .success(let iconUrlString):
                    self.circle.icon = iconUrlString
                    self.saveCircleAction(self.circle)
                case .failure:
                    self.errorInput.onNext(true)
                }
            }
        } else if backgroundImage != nil {
            StorageService.downLoadImage(image: self.backgroundImage!) { result in
                switch result {
                case .success(let backGroundUrl):
                    self.circle.backGround = backGroundUrl
                    self.saveCircleAction(self.circle)
                case .failure:
                    self.errorInput.onNext(true)
                }
            }
        }
    }
    
    func addFeatures(_ feature: CircleFeatures) {
    if !judgeFeatures(feature) {
            selectionsFeature.append(feature.description)
        } else {
            selectionsFeature.remove(value: feature.description)
        }
        circle.features = self.selectionsFeature
    }
    
    func judgeFeatures(_ feature: CircleFeatures) -> Bool {
        return selectionsFeature.contains(feature.description)
    }
    
    func saveCircleAction(_ circle: Circle) {
        circleAPI.updateCircle(circle: circle).subscribe(onCompleted: {
            self.completedInput.onNext(())
        }, onError: { [weak self] _ in
            self?.errorInput.onNext(true)
        }).disposed(by: disposeBag)
    }
}

extension UpdateCircleViewModel: UpdateCircleViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    
    var nameTextInputs: AnyObserver<String> {
        return nameTextSubject.asObserver()
    }
    var priceTextInputs: AnyObserver<String> {
        return priceTextSubject.asObserver()
    }
    var placeTextInputs: AnyObserver<String> {
        return placeTextSubject.asObserver()
    }
    var textViewInputs: AnyObserver<String> {
        return textViewSubject.asObserver()
    }
    var dateTextInput: AnyObserver<String> {
        return dateTextSubject.asObserver()
    }
}

extension UpdateCircleViewModel: UpdateCircleViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    
    
}
