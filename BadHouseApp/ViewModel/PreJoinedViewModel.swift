import RxRelay
import RxSwift

protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}

protocol PreJoinedViewModelInputs {
    func permission(_ preJoined: PreJoined)
    var reloadInput: AnyObserver<Void> { get }
    var completedInput: AnyObserver<Void> { get }
    var navigationTitleInput: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
}

protocol PreJoinedViewModelOutputs {
    var isError: Observable<Bool> { get }
    var preJoinedList: BehaviorRelay<[PreJoined]> { get }
    var reload: Observable<Void> { get }
    var completed: Observable<Void> { get }
    var navigationTitle: Observable<String> { get }
}

final class PreJoinedViewModel: PreJoinedViewModelType {
    
    var inputs: PreJoinedViewModelInputs { return self }
    var outputs: PreJoinedViewModelOutputs { return self }
    private let joinAPI: JoinRepositry
    var preJoinedList = BehaviorRelay<[PreJoined]>(value: [])
    private let disposeBag = DisposeBag()
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
            self?.navigationTitleInput.onNext("\(prejoineds.count)人から参加申請が来ています")
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func permission(_ preJoined: PreJoined) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoined.fromUserId, subCollectionName: R.Collection.Users, subId: preJoined.uid)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoined.uid, subCollectionName: R.Collection.Users, subId: preJoined.fromUserId)
        var list = preJoinedList.value
        list.remove(value: preJoined)
        preJoinedList.accept(list)
        reloadInput.onNext(())
        UserRepositryImpl.getUserById(uid: preJoined.fromUserId) { friend in
            self.joinAPI.postMatchJoin(preJoined: preJoined, user: friend, myData: self.user).subscribe(onCompleted: {
                self.completedInput.onNext(())
            }, onError: { _ in
                self.errorInput.onNext(true)
            }).disposed(by: self.disposeBag)
        }
    }
}

extension PreJoinedViewModel: PreJoinedViewModelInputs {
    var reloadInput: AnyObserver<Void>  {
        reloadStream.asObserver()
    }
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    var navigationTitleInput: AnyObserver<String> {
        navigationTitleStream.asObserver()
    }
    var errorInput: AnyObserver<Bool> {
        errorInput.asObserver()
    }
}
extension PreJoinedViewModel: PreJoinedViewModelOutputs {
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    var navigationTitle: Observable<String> {
        navigationTitleStream.asObservable()
    }
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}
