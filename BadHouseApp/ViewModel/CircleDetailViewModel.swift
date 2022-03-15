import RxSwift
import RxRelay
import ReSwift

protocol CircleDetailViewModelInputs {
    func changeMember(_ index: Int)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
    var rightButtonHiddenInput: AnyObserver<Bool> { get }
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol CircleDetailViewModelOutputs {
    var memberRelay: BehaviorRelay<[User]> { get }
    var isRightButtonHidden: Observable<Bool> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

protocol CircleDetailViewModelType {
    var inputs: any CircleDetailViewModelInputs { get }
    var outputs: any CircleDetailViewModelOutputs { get }
}

final class CircleDetailViewModel: CircleDetailViewModelType {
    
    var inputs: CircleDetailViewModelInputs { return self }
    var outputs: CircleDetailViewModelOutputs { return self }
    
    var allMembers = [User]()
    var friendsMembers = [User]()
    var genderPercentage = [Int]()
    var levelPercentage = [Int]()
    var circle: Circle

    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let myData: User
    let memberRelay = BehaviorRelay<[User]>(value: [])
    
    private let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let buttonHiddenStream = PublishSubject<Bool>()
    private let store: Store<AppState>
    private let actionCreator: CircleDetailActionCreator
    private let disposeBag = DisposeBag()
    
    init(myData: User,
         circle: Circle,
         store: Store<AppState>,
         actionCreator: CircleDetailActionCreator) {
        self.myData = myData
        self.circle = circle
        self.store = store
        self.actionCreator = actionCreator
        
        setupData()
        setupSubscribe()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.circleDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        actionCreator.getMembers(ids: ids, circle: circle)
    }
    
    func changeMember(_ index: Int) {
        if index == 0 {
            memberRelay.accept(allMembers)
        } else {
            memberRelay.accept(friendsMembers)
        }
        reloadInput.onNext(())
    }

    func getPercentage() {
        circle.charts = Circle.ChartsObject(members: allMembers)
        genderPercentage = circle.charts?.makeGenderPer() ?? [0]
        levelPercentage = circle.charts?.makeLevelPer() ?? [0]
    }
    
    private func checkRightButtonHidden(_ users: [User]) {
        var isHidden = true
        users.forEach { user in
            if user.isMyself {
               isHidden = false
            }
        }
        rightButtonHiddenInput.onNext(isHidden)
    }
    
}

extension CircleDetailViewModel: CircleDetailViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    var rightButtonHiddenInput: AnyObserver<Bool> {
        buttonHiddenStream.asObserver()
    }
}

extension CircleDetailViewModel: CircleDetailViewModelOutputs {
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var isRightButtonHidden: Observable<Bool> {
        buttonHiddenStream.asObservable()
    }
}

extension CircleDetailViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = CircleDetailState
    
    func newState(state: CircleDetailState) {
        allMembersStateSubscribe(state)
        friendsMembers(state)
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        circleStateSubscribe(state)
    }
    
    func allMembersStateSubscribe(_ state: CircleDetailState) {
        allMembers = state.allMembers
        checkRightButtonHidden(state.allMembers)
        getPercentage()
    }
    
    func friendsMembers(_ state: CircleDetailState) {
        friendsMembers = state.friendsMembers
    }
    
    func errorStateSubscribe(_ state: CircleDetailState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStauts()
        }
    }
    
    func reloadStateSubscribe(_ state: CircleDetailState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStaus()
        }
    }
    
    func circleStateSubscribe(_ state: CircleDetailState) {
        if let circle = state.circle {
            self.circle = circle
            memberRelay.accept(circle.members)
        }
    }
}
