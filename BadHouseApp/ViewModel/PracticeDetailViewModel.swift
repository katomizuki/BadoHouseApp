import RxRelay
import RxSwift
import ReSwift

protocol PracticeDetailViewModelType {
    var inputs: PracticeDetailViewModelInputs { get }
    var outputs: PracticeDetailViewModelOutputs { get }
}

protocol PracticeDetailViewModelInputs {
    func onTapTakePartInButton()
    var errorInput: AnyObserver<Bool> { get }
    var completedInput: AnyObserver<Void> { get }
    var takePartInButtonInput: AnyObserver<Bool> { get }
    var buttonHiddenInput: AnyObserver<Bool> { get }
}

protocol PracticeDetailViewModelOutputs {
    var userRelay: PublishRelay<User> { get }
    var circleRelay: PublishRelay<Circle> { get }
    var isError: Observable<Bool> { get }
    var isButtonHidden: Observable<Bool> { get }
    var completed: Observable<Void> { get }
    var isTakePartInButton: Observable<Bool> { get }
}

final class PracticeDetailViewModel: PracticeDetailViewModelType {

    var inputs: any PracticeDetailViewModelInputs { self }
    var outputs: any PracticeDetailViewModelOutputs { self }

    var circle: Circle?
    var user: User?

    let practice: Practice
    let myData: User
    let isModal: Bool
    let userRelay = PublishRelay<User>()
    let circleRelay = PublishRelay<Circle>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let buttonHiddenStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let takePartInButtonStream = PublishSubject<Bool>()
    private let store: Store<AppState>
    private let actionCreator: PracticeActionCreator
   
    init(practice: Practice,
         isModal: Bool,
         store: Store<AppState>,
         actionCreator: PracticeActionCreator,
         myData: User) {
        self.practice = practice
        self.isModal = isModal
        self.store = store
        self.actionCreator = actionCreator
        self.myData = myData
        
        setupSubscribe()
        setupData()
        setupUI()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.practiceDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupData() {
        actionCreator.getUser(uid: practice.userId)
        actionCreator.getCircle(circleId: practice.circleId)
    }
    
    func setupUI() {
        guard let user = user else { return }
        actionCreator.checkButtonHidden(uid: myData.uid, user: user, isModal: isModal)
    }
    
    func onTapTakePartInButton() {
        guard let user = user else { return }
        actionCreator.takePartInPractice(user: user, myData: myData, practice: practice)
        actionCreator.saveUserDefaults(practice: practice)
    }
}

extension PracticeDetailViewModel: PracticeDetailViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    var buttonHiddenInput: AnyObserver<Bool> {
        buttonHiddenStream.asObserver()
    }
    var takePartInButtonInput: AnyObserver<Bool> {
        takePartInButtonStream.asObserver()
    }
}
extension PracticeDetailViewModel: PracticeDetailViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    var isButtonHidden: Observable<Bool> {
        buttonHiddenStream.asObservable()
    }
    
    var isTakePartInButton: Observable<Bool> {
        takePartInButtonStream.asObservable()
    }
}

extension PracticeDetailViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = PracticeDetailState
    
    func newState(state: PracticeDetailState) {
        userStateSubscribe(state)
        circleStateSubscribe(state)
        errroStatusSubscribe(state)
        completedStatusSubscribe(state)
        buttonHiddenStatusSubscribe(state)
        takePartInButtonSubscribe(state)
    }
    
    func errroStatusSubscribe(_ state: PracticeDetailState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func circleStateSubscribe(_ state: PracticeDetailState) {
        if let circle = state.circle {
            self.circle = circle
            self.circleRelay.accept(circle)
        }
    }
    
    func userStateSubscribe(_ state: PracticeDetailState) {
        if let user = state.user {
            self.userRelay.accept(user)
            self.user = user
        }
    }
    
    func completedStatusSubscribe(_ state: PracticeDetailState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompletedStatus()
        }
    }
    
    func buttonHiddenStatusSubscribe(_ state: PracticeDetailState) {
        buttonHiddenInput.onNext(state.buttonHidden)
    }
    
    func takePartInButtonSubscribe(_ state: PracticeDetailState) {
        takePartInButtonInput.onNext(state.isTakePartInButton)
    }
}
