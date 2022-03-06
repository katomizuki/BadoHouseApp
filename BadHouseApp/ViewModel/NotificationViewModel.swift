import RxSwift
import Foundation
import RxRelay
import ReSwift

protocol NotificationViewModelInputs {
    func didTapCell(_ row: Int)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol NotificationViewModelOutputs {
    var notificationList: BehaviorRelay<[Notification]> { get }
    var errorOutput: Observable<Bool> { get }
    var reloadOuput: Observable<Void> { get }
    var toPrejoined: PublishSubject<Void> { get }
    var toApplyedFriend: PublishSubject<Void> { get }
    var toUserDetail: PublishSubject<User> { get }
    var toPracticeDetail: PublishSubject<Practice> { get }
}

protocol NotificationViewModelType {
    var inputs: NotificationViewModelInputs { get }
    var outputs: NotificationViewModelOutputs { get }
}

final class NotificationViewModel: NotificationViewModelType {
    
    var inputs: NotificationViewModelInputs { return self }
    var outputs: NotificationViewModelOutputs { return self }
    var notificationList = BehaviorRelay<[Notification]>(value: [])
    var toPrejoined = PublishSubject<Void>()
    var toApplyedFriend = PublishSubject<Void>()
    var toUserDetail = PublishSubject<User>()
    var toPracticeDetail = PublishSubject<Practice>()
    let user: User
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let prejoinedStream = PublishSubject<Void>()
    private let applyedFriendStream = PublishSubject<Void>()
    private let userDetailStream = PublishSubject<User>()
    private let practiceDetailStream = PublishSubject<Practice>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: NotificationActionCreator
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: NotificationActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        setupData()
        setupSubscribe()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.notificationStatus }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupData() {
        actionCreator.getNotification(user: user)
    }
    
    func didTapCell(_ row: Int) {
        let notification = self.notificationList.value[row]
        switch notification.notificationSelection {
        case .prejoined:
            self.toPrejoined.onNext(())
        case .applyed:
            self.toApplyedFriend.onNext(())
        case .permissionFriend:
            UserRepositryImpl.getUserById(uid: notification.id) { user in
                self.toUserDetail.onNext(user)
            }
        case .permissionJoin:
            PracticeRepositryImpl.getPracticeById(id: notification.practiceId) { practice in
                self.toPracticeDetail.onNext(practice)
            }
        }
    }
}

extension NotificationViewModel: NotificationViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}
extension NotificationViewModel: NotificationViewModelOutputs {
    var errorOutput: Observable<Bool> {
        errorStream.asObservable()
    }
    var reloadOuput: Observable<Void> {
        reloadStream.asObservable()
    }
}

extension NotificationViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = NotificationStatus
    
    func newState(state: StoreSubscriberStateType) {
        notificationStateSubscribe(state)
        errorStateSubscribe(state)
    }
    
    func notificationStateSubscribe(_ state: NotificationStatus) {
        notificationList.accept(state.notifications)
    }
    
    func errorStateSubscribe(_ state: NotificationStatus) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
}
