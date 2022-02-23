import RxSwift
import FirebaseAuth
import RxRelay

protocol TalkViewModelInputs {
    func willAppear()
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol TalkViewModelOutputs {
    var reload: Observable<Void> { get }
    var isError: Observable<Bool> { get }
    var chatRoomList: BehaviorRelay<[ChatRoom]> { get }
}

protocol TalkViewModelType {
    var inputs: TalkViewModelInputs { get }
    var outputs: TalkViewModelOutputs { get }
}

final class TalkViewModel: TalkViewModelType {
    
    var inputs: TalkViewModelInputs { return self }
    var outputs: TalkViewModelOutputs { return self }
    

    let chatRoomList = BehaviorRelay<[ChatRoom]>(value: [])
    private let disposeBag = DisposeBag()
    private let userAPI: UserRepositry
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    init(userAPI: UserRepositry) {
        self.userAPI = userAPI
    }
    
    func willAppear() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userAPI.getMyChatRooms(uid: uid).subscribe { [weak self] chatRooms in
            self?.chatRoomList.accept(chatRooms)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
}

extension TalkViewModel: TalkViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}
extension TalkViewModel: TalkViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}
