import RxSwift
import RxRelay
import ReSwift

protocol InviteViewModelInputs {
    var errorInput: AnyObserver<Bool> { get }
    var completedInput: AnyObserver<Void> { get }
}

protocol InviteViewModelOutputs {
    var isError: Observable<Bool> { get }
    var friendsList: BehaviorRelay<[User]> { get }
    var isCompleted: Observable<Void> { get }
}

protocol InviteViewModelType {
    var inputs: InviteViewModelInputs { get  }
    var outputs: InviteViewModelOutputs { get }
}

final class InviteViewModel: InviteViewModelType {
    
    var inputs: InviteViewModelInputs { return self }
    var outputs: InviteViewModelOutputs { return self }
    
    var user: User
    var form: Form
    var inviteIds = [String]()
    var friendsList = BehaviorRelay<[User]>(value: [])
    
    private let disposeBag = DisposeBag()
    private var dic = [String: Any]()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: InviteActionCreator
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    
    init(user: User,
         form: Form,
         store: Store<AppState>,
         actionCreator: InviteActionCreator) {
        self.user = user
        self.form = form
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        setupData()
        makeDic()
    }
    
    func setupData() {
        actionCreator.getFriends(user: user)
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.inviteState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupBackGroundImage() {
        if let image = form.background {
            StorageService.downLoadImage(image: image) { result in
                switch result {
                case .success(let urlString):
                    self.dic["backGround"] = urlString
                case .failure:
                    self.errorInput.onNext(true)
                }
            }
        } else {
            dic["backGround"] = ""
        }
    }
    
    func setupIconImage() {
        if let icon = self.form.icon {
            StorageService.downLoadImage(image: icon) { result in
                switch result {
                case .success(let urlString):
                    self.dic["icon"] = urlString
                case .failure:
                    self.errorInput.onNext(true)
                }
            }
        } else {
            dic["icon"] = ""
        }
    }
    
    func inviteAction(user: User?) {
        guard let user = user else { return }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    
    func makeCircle() {
        inviteIds.append(user.uid)
        dic["member"] = inviteIds
        self.actionCreator.makeCircle(user: user, dic: dic, inviteIds: inviteIds)
    }
    
    private func makeDic() {
        let id = Ref.CircleRef.document().documentID
        dic = ["id": id,
                   "name": form.name,
                   "price": form.price,
                   "place": form.place,
                   "time": form.time,
               "features": form.features,
               "additionlText": form.additionlText]
        setupBackGroundImage()
        setupIconImage()
    }
}

extension InviteViewModel: InviteViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    
}

extension InviteViewModel: InviteViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var isCompleted: Observable<Void> {
        completedStream.asObservable()
    }
}

extension InviteViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = InviteState
    
    func newState(state: InviteState) {
        errorStateSubscribe(state)
        completedStateSubscribe(state)
        friendsStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: InviteState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func completedStateSubscribe(_ state: InviteState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompletedStatus()
        }
    }
    
    func friendsStateSubscribe(_ state: InviteState) {
        friendsList.accept(state.friends)
    }
}
