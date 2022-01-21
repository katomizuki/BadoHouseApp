import RxSwift
import FirebaseAuth
import RxRelay
protocol TalkViewModelInputs {
    func willAppear()
}
protocol TalkViewModelOutputs {
    var reload: PublishSubject<Void> { get }
    var isError: PublishSubject<Bool> { get }
    var chatRoomList: BehaviorRelay<[ChatRoom]> { get }
}
protocol TalkViewModelType {
    var inputs: TalkViewModelInputs { get }
    var outputs: TalkViewModelOutputs { get }
}
final class TalkViewModel: TalkViewModelType, TalkViewModelInputs, TalkViewModelOutputs {
    var inputs: TalkViewModelInputs { return self }
    var outputs: TalkViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var chatRoomList = BehaviorRelay<[ChatRoom]>(value: [])
    private let disposeBag = DisposeBag()
    var userAPI: UserServiceProtocol
    var chatAPI: ChatServiceProtocol
    init(userAPI: UserServiceProtocol, chatAPI: ChatServiceProtocol) {
        self.chatAPI = chatAPI
        self.userAPI = userAPI
    }
    func willAppear() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userAPI.getMyChatRooms(uid: uid).subscribe { [weak self] chatRooms in
            self?.chatRoomList.accept(chatRooms)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
}
