import RxRelay
import RxSwift
import FirebaseAuth
import UIKit
import ReSwift
protocol PracticeDetailViewModelType {
    var inputs: PracticeDetailViewModelInputs { get }
    var outputs: PracticeDetailViewModelOutputs { get }
}

protocol PracticeDetailViewModelInputs {
    func takePartInPractice()
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

    var inputs: PracticeDetailViewModelInputs { return self }
    var outputs: PracticeDetailViewModelOutputs { return self }

    var userRelay = PublishRelay<User>()
    var circleRelay = PublishRelay<Circle>()

    let practice: Practice
    var myData: User?
    var circle: Circle?
    var user: User?
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let buttonHiddenStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let takePartInButtonStream = PublishSubject<Bool>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: PracticeActionCreator
    let isModal: Bool
    
    init(practice: Practice,
         isModal: Bool, store: Store<AppState>,actionCreator: PracticeActionCreator) {
        self.practice = practice
        self.isModal = isModal
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.practiceDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        self.actionCreator.getUser(uid: practice.userId)
        self.actionCreator.getCircle(circleId: practice.circleId)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = user else { return }
        self.actionCreator.checkButtonHidden(uid: uid, user: user, isModal: self.isModal)
 
    }
    
    func takePartInPractice() {
        guard let user = user else { return }
        guard let myData = myData else { return }
        self.actionCreator.takePartInPractice(user: user, myData: myData, practice: self.practice)
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
    var isError:Observable<Bool> {
        errorStream.asObservable()
    }
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    var isButtonHidden:Observable<Bool> {
        buttonHiddenStream.asObservable()
    }
    
    var isTakePartInButton:Observable<Bool> {
        takePartInButtonStream.asObservable()
    }
}

extension PracticeDetailViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = PracticeDetailState
    
    func newState(state: PracticeDetailState) {

        if let user = state.user {
            self.userRelay.accept(user)
            self.user = user
        }
        if let myData = state.myData {
            self.myData = myData
        }
        if let circle = state.circle {
            self.circle = circle
            self.circleRelay.accept(circle)
        }
        if state.errorStatus {
            errorInput.onNext(true)
        }
        if state.completedStatus {
            completedInput.onNext(())
        }
        buttonHiddenInput.onNext(state.buttonHidden)
        takePartInButtonInput.onNext(state.isTakePartInButton)
    }
}
