import RxSwift
import RxRelay
import Foundation
import ReSwift

protocol ApplyedUserListViewModelInputs {
    func makeFriends(_ applyed: Applyed)
    func deleteFriends(_ applyed: Applyed)
    var errorInput: AnyObserver<Bool> { get }
    var completedFriendInput: AnyObserver<String> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ApplyedUserListViewModelOutputs {
    var applyedRelay: BehaviorRelay<[Applyed]> { get }
    var completedFriend: Observable<String> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
    var navigationTitle: PublishSubject<String> { get }
}

protocol ApplyedUserListViewModelType {
    var inputs: ApplyedUserListViewModelInputs { get }
    var outputs: ApplyedUserListViewModelOutputs { get }
}

final class ApplyedUserListViewModel: ApplyedUserListViewModelType {
    
    var inputs: any ApplyedUserListViewModelInputs {  self }
    var outputs: any ApplyedUserListViewModelOutputs {  self }
    
    let applyedRelay = BehaviorRelay<[Applyed]>(value: [])
    let navigationTitle = PublishSubject<String>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<String>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: ApplyedUserListActionCreator
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: ApplyedUserListActionCreator) {
        self.user = user
        self.actionCreator = actionCreator
        self.store = store
        
        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.applyedUserListState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupData() {
        actionCreator.getApplyedUserList(user)
    }
}

extension ApplyedUserListViewModel: ApplyedUserListViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }

    var completedFriendInput: AnyObserver<String> {
        completedStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func makeFriends(_ applyed: Applyed) {
        actionCreator.makeFriends(applyed, uid: user.uid, list: applyedRelay.value, user: user)
    }
    
    func deleteFriends(_ applyed: Applyed) {
        actionCreator.deleteFriends(applyed, uid: user.uid, list: applyedRelay.value)
    }
}

extension ApplyedUserListViewModel: ApplyedUserListViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var completedFriend: Observable<String> {
        completedStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
}

extension ApplyedUserListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = ApplyedUserListState
    
    func newState(state: ApplyedUserListState) {
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        applyedStateSubscribe(state)
        navigationTitleStateSubscribe(state)
        friendsNameStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: ApplyedUserListState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func reloadStateSubscribe(_ state: ApplyedUserListState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func applyedStateSubscribe(_ state: ApplyedUserListState) {
        applyedRelay.accept(state.applied)
    }
    
    func navigationTitleStateSubscribe(_ state: ApplyedUserListState) {
        navigationTitle.onNext(state.navigationTitle)
    }
    
    func friendsNameStateSubscribe(_ state: ApplyedUserListState) {
        if state.friendName != String() {
            completedFriendInput.onNext(state.friendName)
        }
    }
}
