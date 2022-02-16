import RxSwift
import RxRelay

protocol InviteViewModelInputs {
    func willAppear()
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
    
    var userAPI: UserRepositry
    var user: User
    var form: Form
    var inviteIds = [String]()
    var friendsList = BehaviorRelay<[User]>(value: [])
    
    private let disposeBag = DisposeBag()
    private var dic = [String: Any]()
    private let circleAPI: CircleRepositry
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    
    init(userAPI: UserRepositry,
         user: User,
         form: Form,
         circleAPI: CircleRepositry) {
        self.userAPI = userAPI
        self.user = user
        self.form = form
        self.circleAPI = circleAPI
        userAPI.getFriends(uid: user.uid).subscribe {[weak self] users in
            self?.friendsList.accept(users)
        } onFailure: {[weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
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
        guard let user = user else {
            return
        }
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
        circleAPI.postCircle(id: dic["id"] as? String ?? "",
                                 dic: dic,
                                 user: user,
                                 memberId: inviteIds) { [weak self] result in
            switch result {
            case .success:
                self?.completedInput.onNext(())
            case .failure:
                self?.errorInput.onNext(true)
            }
        }
    }
}

extension InviteViewModel: InviteViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    
    func willAppear() {
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

extension InviteViewModel: InviteViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var isCompleted: Observable<Void> {
        completedStream.asObservable()
    }
}
