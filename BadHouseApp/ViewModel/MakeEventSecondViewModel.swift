import RxSwift
import RxCocoa
import FirebaseAuth
import UIKit
import ReSwift

protocol MakeEventSecondViewModelInputs {
    var minLevelInput: AnyObserver<Float> { get }
    var maxLevelInput: AnyObserver<Float> { get }
}

protocol MakeEventSecondViewModelOutputs {
    var minLevelText: BehaviorRelay<String> { get }
    var maxLevelText: BehaviorRelay<String> { get }
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var minLevelOutput: Observable<Float> { get }
    var maxLevelOutput: Observable<Float> { get }
}

protocol MakeEventSecondViewModelType {
    var inputs: MakeEventSecondViewModelInputs { get }
    var outputs: MakeEventSecondViewModelOutputs { get }
}

final class MakeEventSecondViewModel: MakeEventSecondViewModelType {
    
    var inputs: any MakeEventSecondViewModelInputs { self }
    var outputs: any MakeEventSecondViewModelOutputs { self }
    
    let minLevelText = BehaviorRelay<String>(value: "レベル1")
    let maxLevelText = BehaviorRelay<String>(value: "レベル10")
    let circleRelay = BehaviorRelay<[Circle]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    var user: User?
    var circle: Circle?
    var title: String
    var image: UIImage
    var kind: String
    var dic: [String: Any] = [String: Any]()
    
    private let minLevelStream = PublishSubject<Float>()
    private let maxLevelStream = PublishSubject<Float>()
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: MakeEventSecondActionCreator
    
    init(title: String,
         image: UIImage,
         kind: String,
         store: Store<AppState>,
         actionCreator: MakeEventSecondActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        self.title = title
        self.image = image
        self.kind = kind
        self.dic["title"] = title
        self.dic["kind"] = kind
        
        setupSubscribe()
        setupData()
        setupBind()
    }
    
    private func setupData() {
        actionCreator.getCircle(AuthRepositryImpl.getUid() ?? "")
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.makeEventSecond }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupBind() {
        minLevelOutput.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            let minText = self.changeNumber(num: value)
            self.minLevelText.accept(minText)
        }).disposed(by: disposeBag)
        
        maxLevelOutput.subscribe(onNext: {[weak self] value in
            guard let self = self else { return }
            let maxText = self.changeNumber(num: value)
            self.maxLevelText.accept(maxText)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    func changeNumber(num: Float) -> String {
        // TODO: - ここのヘルパー関数はドメインロジックに近い気もするのでここに書いてはダメ
        var message: String = String()
        switch num * Float(10) {
        case 0..<1:
            message = BadmintonLevel(rawValue: 0)!.description
        case 1..<2:
            message = BadmintonLevel(rawValue: 1)!.description
        case 2..<3:
            message = BadmintonLevel(rawValue: 2)!.description
        case 3..<4:
            message = BadmintonLevel(rawValue: 3)!.description
        case 4..<5:
            message = BadmintonLevel(rawValue: 4)!.description
        case 5..<6:
            message = BadmintonLevel(rawValue: 5)!.description
        case 6..<7:
            message = BadmintonLevel(rawValue: 6)!.description
        case 7..<8:
            message = BadmintonLevel(rawValue: 7)!.description
        case 8..<9:
            message = BadmintonLevel(rawValue: 8)!.description
        case 9...10:
            message = BadmintonLevel(rawValue: 9)!.description
        default:
            break
        }
        return message
    }
}

extension MakeEventSecondViewModel: MakeEventSecondViewModelInputs {
    
    var minLevelInput: AnyObserver<Float> {
        minLevelStream.asObserver()
    }
    
    var maxLevelInput: AnyObserver<Float> {
        maxLevelStream.asObserver()
    }
}

extension MakeEventSecondViewModel: MakeEventSecondViewModelOutputs {
    
    var maxLevelOutput: Observable<Float> {
        maxLevelStream.asObservable()
    }
    
    var minLevelOutput: Observable<Float> {
        minLevelStream.asObservable()
    }
    
}
extension MakeEventSecondViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = MakeEventSecondState
    func newState(state: MakeEventSecondState) {
        circleStateSubscribe(state)
        userStateSubscribe(state)
    }
    
    func circleStateSubscribe(_ state: MakeEventSecondState) {
        circleRelay.accept(state.circle)
    }
    
    func userStateSubscribe(_ state: MakeEventSecondState) {
        if let user = state.user {
            self.user = user
        }
    }
}
