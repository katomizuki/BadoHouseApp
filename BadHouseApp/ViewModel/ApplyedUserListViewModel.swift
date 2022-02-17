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
    
    var inputs: ApplyedUserListViewModelInputs { return self }
    var outputs: ApplyedUserListViewModelOutputs { return self }
    
    var applyedRelay = BehaviorRelay<[Applyed]>(value: [])
    var navigationTitle = PublishSubject<String>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    
    private let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<String>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: ApplyedUserListActionCreator
    
    init(user: User, store: Store<AppState>, actionCreator: ApplyedUserListActionCreator) {
        self.user = user
        self.actionCreator = actionCreator
        self.store = store
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.applyedUserListState }
            }
            self.getApplyedUserList()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func saveFriendsId(id: String) {
        self.actionCreator.saveId(id: id)
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
    
    func getApplyedUserList() {
        self.actionCreator.getApplyedUserList(self.user)
    }
    
    func makeFriends(_ applyed: Applyed) {
        actionCreator.makeFriends(applyed, uid: user.uid, list: applyedRelay.value, user: user)
    }
    
    func deleteFriends(_ applyed: Applyed) {
        self.actionCreator.deleteFriends(applyed, uid: user.uid, list: applyedRelay.value)
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
        
        if state.errorStatus {
            errorInput.onNext(true)
        }
        
        if state.reloadStatus {
            reloadInput.onNext(())
        }
        
        applyedRelay.accept(state.applied)
        navigationTitle.onNext(state.navigationTitle)
        
        if state.friendName != String() {
            completedFriendInput.onNext(state.friendName)
        }
    }
}
