import RxSwift
import RxRelay
import ReSwift

protocol CircleDetailViewModelInputs {
    func changeMember(_ index: Int)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
    var rightButtonHiddenInput: AnyObserver<Bool> { get }
}

protocol CircleDetailViewModelOutputs {
    var memberRelay: BehaviorRelay<[User]> { get }
    var isRightButtonHidden: Observable<Bool> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

protocol CircleDetailViewModelType {
    var inputs: CircleDetailViewModelInputs { get }
    var outputs: CircleDetailViewModelOutputs { get }
}

final class CircleDetailViewModel: CircleDetailViewModelType {
    
    var inputs: CircleDetailViewModelInputs { return self }
    var outputs: CircleDetailViewModelOutputs { return self }
    
    var memberRelay = BehaviorRelay<[User]>(value: [])

    private let disposeBag = DisposeBag()
    var circle: Circle
    let myData: User
    var allMembers = [User]()
    var friendsMembers = [User]()
    var genderPercentage = [Int]()
    var levelPercentage = [Int]()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    
    private let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let buttonHiddenStream = PublishSubject<Bool>()
    private let store: Store<AppState>
    private let actionCreator: CircleDetailActionCreator
    
    init(myData: User, circle: Circle, circleAPI: CircleRepositry, store: Store<AppState>, actionCreator: CircleDetailActionCreator) {
        self.myData = myData
        self.circle = circle
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.circleDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        self.actionCreator.getMembers(ids: self.ids, circle: self.circle)
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
        var (men, women, other) = (0, 0, 0)
        var (one, two, three, four, five, six, seven, eight, nine, ten) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        allMembers.forEach {
            switch $0.gender {
            case "男性":men += 1
            case "女性":women += 1
            default:other += 1
            }
            switch $0.level {
            case "レベル1":one += 1
            case "レベル2":two += 1
            case "レベル3":three += 1
            case "レベル4":four += 1
            case "レベル5":five += 1
            case "レベル6":six += 1
            case "レベル7": seven += 1
            case "レベル8":eight += 1
            case "レベル9":nine += 1
            case "レベル10":ten += 1
            default:break
            }
        }
        genderPercentage = [men, women, other]
        levelPercentage = [one, two, three, four, five, six, seven, eight, nine, ten]
    }
    
    private func checkRightButtonHidden(_ users: [User]) {
        var isHidden = true
        users.forEach { user in
           if user.uid == myData.uid {
               isHidden = false
            }
        }
        self.rightButtonHiddenInput.onNext(isHidden)
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
        self.allMembers = state.allMembers
        self.friendsMembers = state.friendsMembers
        if let circle = state.circle {
            self.circle = circle
            self.memberRelay.accept(circle.members)
        }
        
        if state.errorStatus {
            self.errorInput.onNext(true)
            actionCreator.toggleErrorStauts()
        }
        
        if state.reloadStatus {
            self.reloadInput.onNext(())
            actionCreator.toggleReloadStaus()
        }
        
        self.checkRightButtonHidden(state.allMembers)
        self.getPercentage()
    }
}
