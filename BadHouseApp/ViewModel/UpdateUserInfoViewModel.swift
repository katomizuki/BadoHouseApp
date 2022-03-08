import RxSwift
import Firebase
import RxRelay
import UIKit
import ReSwift

protocol UpdateUserInfoViewModelInputs {
    func saveUser()
    var textViewInputs: AnyObserver<String> { get }
    var nameTextFieldInputs: AnyObserver<String> { get }
    var racketTextFieldInputs: AnyObserver<String> { get }
    var playerTextFieldInputs: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
    var completedInput: AnyObserver<Void> { get }
    var placeInput: AnyObserver<String> { get }
    var genderInput: AnyObserver<String> { get }
    var ageInput: AnyObserver<String> { get }
    var levelInput: AnyObserver<String> { get }
    var badmintonTimeInput: AnyObserver<String> { get }
}

protocol UpdateUserInfoViewModelOutputs {
    var isError: Observable<Bool> { get }
    var userOutput: Observable<User> { get }
    var genderOutput: Observable<String> { get }
    var badmintonTimeOutput: Observable<String> { get }
    var placeOutput: Observable<String> { get }
    var ageOutput: Observable<String> { get }
    var levelOutput: Observable<String> { get }
    var reload: Observable<Void> { get }
    var isCompleted: Observable<Void> { get }
    var textViewSubject: BehaviorSubject<String> { get }
    var nameTextFieldSubject: BehaviorSubject<String> { get }
    var rackeTextFieldSubject: BehaviorSubject<String> { get }
    var playerTextFieldSubject: BehaviorSubject<String> { get }
    var userImage: UIImage? { get }
}

protocol UpdateUserInfoViewModelType {
    var inputs: UpdateUserInfoViewModelInputs { get }
    var outputs: UpdateUserInfoViewModelOutputs { get }
}

final class UpdateUserInfoViewModel: UpdateUserInfoViewModelType {
    
    var inputs: UpdateUserInfoViewModelInputs { return self }
    var outputs: UpdateUserInfoViewModelOutputs { return self }
    
    var user: User?
    var userImage: UIImage?
    var isChangeImage = false

    let textViewSubject = BehaviorSubject<String>(value: "")
    let nameTextFieldSubject = BehaviorSubject<String>(value: "")
    let rackeTextFieldSubject = BehaviorSubject<String>(value: "")
    let playerTextFieldSubject = BehaviorSubject<String>(value: "")
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let completedStream = PublishSubject<Void>()
    private let placeStream = PublishSubject<String>()
    private let genderStream = PublishSubject<String>()
    private let levelStream = PublishSubject<String>()
    private let badmintonTimeStream = PublishSubject<String>()
    private let ageStream = PublishSubject<String>()
    private let userStream = PublishRelay<User>()
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: UpdateUserInfoActionCreator

    init(store: Store<AppState>,
         actionCreator: UpdateUserInfoActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        setupData()
        setupBinding()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.updateUserState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        nameTextFieldSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.user?.name = text
        }).disposed(by: disposeBag)
        
        playerTextFieldSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.user?.player = text
        }).disposed(by: disposeBag)
        
        textViewSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.user?.introduction = text
        }).disposed(by: disposeBag)
        
        rackeTextFieldSubject.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.user?.racket = text
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        guard let uid = AuthRepositryImpl.getUid() else { return }
        self.actionCreator.getUser(uid: uid)
    }

    
    func saveUser() {
        guard let user = user else { return }
        var dic: [String: Any] = ["name": user.name,
                                "email": user.email,
                                "createdAt": user.createdAt,
                                "updatedAt": Timestamp(),
                                "introduction": user.introduction,
                                "profileImageUrl": user.profileImageUrlString,
                                "level": user.level,
                                "gender": user.gender,
                                "place": user.place,
                                "badmintonTime": user.badmintonTime,
                                "age": user.age,
                                "racket": user.racket,
                                 "player": user.player,
                                 "uid": user.uid]
        if isChangeImage {
            StorageService.downLoadImage(image: userImage!) { [weak self] result in
                switch result {
                case .success(let urlString):
                    dic["profileImageUrl"] = urlString
                    self?.postUser(dic: dic)
                case .failure:
                    self?.errorInput.onNext(true)
                }
            }
        } else {
           postUser(dic: dic)
        }
    }
    
    func postUser(dic: [String: Any]) {
        guard let uid = AuthRepositryImpl.getUid() else { return }
        self.actionCreator.postUser(dic: dic, uid: uid)
    }
    
    func getUserData(_ selection: UserInfoSelection) -> String {
        guard let user = user else { return "未設定" }
        switch selection {
        case .level:
            return user.level
        case .gender:
            return user.gender
        case .badmintonTime:
            return user.badmintonTime
        case .place:
            return user.place
        case .age:
            return user.age
        }
    }
    
    func changeUser(_ userInfoSelecition: UserInfoSelection,
                    text: String) {
        switch userInfoSelecition {
        case .level:
            user?.level = text
        case .gender:
            user?.gender = text
        case .badmintonTime:
            user?.badmintonTime = text
        case .place:
            user?.place = text
        case .age:
            user?.age = text
        }
        self.reloadInput.onNext(())
    }
}

extension UpdateUserInfoViewModel: UpdateUserInfoViewModelInputs {
    var genderInput: AnyObserver<String> {
        genderStream.asObserver()
    }
    
    var ageInput: AnyObserver<String> {
        ageStream.asObserver()
    }
    
    var levelInput: AnyObserver<String> {
        levelStream.asObserver()
    }
    
    var badmintonTimeInput: AnyObserver<String> {
        badmintonTimeStream.asObserver()
    }
    
    var placeInput: AnyObserver<String> {
        placeStream.asObserver()
    }
    
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    var playerTextFieldInputs: AnyObserver<String> {
         playerTextFieldSubject.asObserver()
    }

    var racketTextFieldInputs: AnyObserver<String> {
         rackeTextFieldSubject.asObserver()
    }

    var nameTextFieldInputs: AnyObserver<String> {
         nameTextFieldSubject.asObserver()
    }

    var textViewInputs: AnyObserver<String> {
         textViewSubject.asObserver()
    }

}

extension UpdateUserInfoViewModel: UpdateUserInfoViewModelOutputs {

    var genderOutput: Observable<String> {
        genderStream.asObserver()
    }
    
    var badmintonTimeOutput: Observable<String> {
        badmintonTimeStream.asObservable()
    }
    
    var ageOutput: Observable<String> {
        ageStream.asObservable()
    }
    
    var levelOutput: Observable<String> {
        levelStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }

    var isCompleted: Observable<Void> {
        completedStream.asObservable()
    }

    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var placeOutput: Observable<String> {
        placeStream.asObservable()
    }
    
    var userOutput: Observable<User> {
        userStream.asObservable()
    }
}
extension UpdateUserInfoViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = UpdateUserInfoState
    
    func newState(state: UpdateUserInfoState) {
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        completedStateSubscribe(state)
        userStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: UpdateUserInfoState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleError()
        }
    }
    
    func reloadStateSubscribe(_ state: UpdateUserInfoState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReload()
        }
    }
    
    func completedStateSubscribe(_ state: UpdateUserInfoState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompleted()
        }
    }
    
    func userStateSubscribe(_ state: UpdateUserInfoState) {
        if let user = state.user {
            self.user = user
            userStream.accept(user)
        }
    }
}
