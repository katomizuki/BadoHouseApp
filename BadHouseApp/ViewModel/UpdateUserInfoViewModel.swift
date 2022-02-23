import RxSwift
import Firebase
import RxRelay
import UIKit

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
}

protocol UpdateUserInfoViewModelOutputs {
    var isError: Observable<Bool> { get }
    var userSubject: PublishSubject<User> { get }
    var genderSubject: PublishSubject<String> { get }
    var badmintonTimeSubject: PublishSubject<String> { get }
    var placeOutput: Observable<String> { get }
    var ageSubject: PublishSubject<String> { get }
    var levelSubject: PublishSubject<String> { get }
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
    var userSubject = PublishSubject<User>()
    var genderSubject = PublishSubject<String>()
    var badmintonTimeSubject = PublishSubject<String>()
    var levelSubject = PublishSubject<String>()
    var ageSubject = PublishSubject<String>()
    
    var textViewSubject = BehaviorSubject<String>(value: "")
    var nameTextFieldSubject = BehaviorSubject<String>(value: "")
    var rackeTextFieldSubject = BehaviorSubject<String>(value: "")
    var playerTextFieldSubject = BehaviorSubject<String>(value: "")
    var userImage: UIImage?
    var isChangeImage = false
    
    let userAPI: UserRepositry
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let completedStream = PublishSubject<Void>()
    private let placeStream = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    init(userAPI: UserRepositry) {
        self.userAPI = userAPI
        if let uid = AuthRepositryImpl.getUid() {
            userAPI.getUser(uid: uid).subscribe { [weak self] user in
                self?.user = user
                self?.userSubject.onNext(user)
                self?.reloadInput.onNext(())
            } onFailure: { [weak self] _ in
                self?.errorInput.onNext(true)
            }.disposed(by: disposeBag)
        }
        
        playerTextFieldSubject.subscribe { [weak self] text in
            self?.user?.player = text
        }.disposed(by: disposeBag)
        
        textViewSubject.subscribe { [weak self] text in
            self?.user?.introduction = text
        }.disposed(by: disposeBag)
        
        rackeTextFieldSubject.subscribe { [weak self] text in
            self?.user?.racket = text
        }.disposed(by: disposeBag)
        
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
        userAPI.postUser(uid: AuthRepositryImpl.getUid()!, dic: dic).subscribe(onCompleted: {
            self.completedInput.onNext(())
        }, onError: { [weak self] _ in
            self?.errorInput.onNext(true)
        }).disposed(by: disposeBag)
    }
    
    func getUserData(_ selection: UserInfoSelection) -> String {
        guard let user = user else {
            return "未設定"
        }
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
}
