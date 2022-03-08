import RxSwift
import RxRelay
import UIKit
import ReSwift

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
    
    var circle: Circle
    var iconImage: UIImage?
    var backgroundImage: UIImage?
    lazy var selectionsFeature = circle.features
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let actionCreator: UpdateCircleActionCreator
    private let nameTextSubject = PublishSubject<String>()
    private let priceTextSubject = PublishSubject<String>()
    private let placeTextSubject = PublishSubject<String>()
    private let dateTextSubject = PublishSubject<String>()
    private let textViewSubject = PublishSubject<String>()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    
    init(circle: Circle,
         store: Store<AppState>,
         actionCreator: UpdateCircleActionCreator) {
        self.circle = circle
        self.store = store
        self.actionCreator = actionCreator
        
       setupSubscribe()
       setupBind()
        
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.updateCircleStaet }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupBind() {
        nameTextSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.circle.name = text
        }).disposed(by: disposeBag)
        
        placeTextSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.circle.place = text
        }).disposed(by: disposeBag)
        
        priceTextSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.circle.price = text
        }).disposed(by: disposeBag)
        
        dateTextSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.circle.time = text
        }).disposed(by: disposeBag)
        
        textViewSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.circle.additionlText = text
        }).disposed(by: disposeBag)
    }
    // 画像を毎回変えないようにする。
    func save() {
        // アイコン画像と背景をどっちも更新
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
            // どっちも更新せず
        } else if iconImage == nil && backgroundImage == nil {
            self.saveCircleAction(circle)
            // アイコン画像のみ
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
            // 背景画像のみ
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
        circle.features = selectionsFeature
    }
    
    func judgeFeatures(_ feature: CircleFeatures) -> Bool {
        return selectionsFeature.contains(feature.description)
    }
    
    func saveCircleAction(_ circle: Circle) {
        self.actionCreator.saveCircleAction(circle)
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
extension UpdateCircleViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = UpdateCircleState
    
    func newState(state: UpdateCircleState) {
        errorStateSubscribe(state)
        completedStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: UpdateCircleState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleError()
        }
    }
    
    func completedStateSubscribe(_ state: UpdateCircleState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompleted()
        }
    }
}
