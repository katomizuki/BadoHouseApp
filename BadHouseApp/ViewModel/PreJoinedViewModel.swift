import RxRelay
import RxSwift

protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}

protocol PreJoinedViewModelInputs {
    func permission(_ preJoined: PreJoined)
}

protocol PreJoinedViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var preJoinedList: BehaviorRelay<[PreJoined]> { get }
    var reload: PublishSubject<Void> { get }
    var completed: PublishSubject<Void> { get }
    var navigationTitle: PublishSubject<String> { get }
}

final class PreJoinedViewModel: PreJoinedViewModelType, PreJoinedViewModelInputs, PreJoinedViewModelOutputs {
    
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var inputs: PreJoinedViewModelInputs { return self }
    var outputs: PreJoinedViewModelOutputs { return self }
    private let joinAPI: JoinRepositry
    var preJoinedList = BehaviorRelay<[PreJoined]>(value: [])
    var navigationTitle = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    var completed = PublishSubject<Void>()
    let user: User
    
    private let reloadStream = PublishSubject<Void>()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let navigationTitleStream = PublishSubject<String>()
    
    init(joinAPI: JoinRepositry, user: User) {
        self.joinAPI = joinAPI
        self.user = user
        joinAPI.getPreJoined(userId: user.uid).subscribe {[weak self] prejoineds in
            self?.preJoinedList.accept(prejoineds)
            self?.navigationTitle.onNext("\(prejoineds.count)人から参加申請が来ています")
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func permission(_ preJoined: PreJoined) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoined.fromUserId, subCollectionName: R.Collection.Users, subId: preJoined.uid)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoined.uid, subCollectionName: R.Collection.Users, subId: preJoined.fromUserId)
        var list = preJoinedList.value
        list.remove(value: preJoined)
        preJoinedList.accept(list)
        reload.onNext(())
        UserRepositryImpl.getUserById(uid: preJoined.fromUserId) { friend in
            self.joinAPI.postMatchJoin(preJoined: preJoined, user: friend, myData: self.user).subscribe(onCompleted: {
                self.completed.onNext(())
            }, onError: { _ in
                self.isError.onNext(true)
            }).disposed(by: self.disposeBag)
        }
    }
}
