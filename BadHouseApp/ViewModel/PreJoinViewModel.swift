import RxSwift
import RxRelay

protocol PreJoinViewModelType {
    var inputs: PreJoinViewModelInputs { get }
    var outputs: PreJoinViewModelOutputs { get }
}

protocol PreJoinViewModelInputs {
    func delete(_ preJoin: PreJoin)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol PreJoinViewModelOutputs {
    var isError: Observable<Bool> { get }
    var preJoinList: BehaviorRelay<[PreJoin]> { get }
    var reload: Observable<Void> { get }
}

final class PreJoinViewModel: PreJoinViewModelType {
    
    var inputs: PreJoinViewModelInputs { return self }
    var outputs: PreJoinViewModelOutputs { return self }
    private let joinAPI: JoinRepositry
    
    let preJoinList =  BehaviorRelay<[PreJoin]>(value: [])
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    init(joinAPI: JoinRepositry, user: User) {
        self.joinAPI = joinAPI
        
        joinAPI.getPrejoin(userId: user.uid).subscribe {[weak self] prejoins in
            self?.preJoinList.accept(prejoins)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func delete(_ preJoin: PreJoin) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoin.uid, subCollectionName: R.Collection.Users, subId: preJoin.toUserId)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoin.toUserId, subCollectionName: R.Collection.Users, subId: preJoin.uid)
        var prejoins: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.preJoin)
        prejoins.remove(value: preJoin.id)
        UserDefaultsRepositry.shared.saveToUserDefaults(element: prejoins, key: R.UserDefaultsKey.preJoin)
        var list = preJoinList.value
        list.remove(value: preJoin)
        preJoinList.accept(list)
        reloadInput.onNext(())
    }
}

extension PreJoinViewModel: PreJoinViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}

extension PreJoinViewModel: PreJoinViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}
