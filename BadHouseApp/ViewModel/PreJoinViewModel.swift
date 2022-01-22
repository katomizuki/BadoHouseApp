import RxSwift
import RxRelay

protocol PreJoinViewModelType {
    var inputs: PreJoinViewModelInputs { get }
    var outputs: PreJoinViewModelOutputs { get }
}

protocol PreJoinViewModelInputs {
    func delete(_ preJoin: PreJoin)
}

protocol PreJoinViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var preJoinList: BehaviorRelay<[PreJoin]> { get }
    var reload: PublishSubject<Void> { get }
}

final class PreJoinViewModel: PreJoinViewModelType, PreJoinViewModelInputs, PreJoinViewModelOutputs {
    
    var inputs: PreJoinViewModelInputs { return self }
    var outputs: PreJoinViewModelOutputs { return self }
    var joinAPI: JoinServiceProtocol
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var preJoinList =  BehaviorRelay<[PreJoin]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(joinAPI: JoinServiceProtocol, user: User) {
        self.joinAPI = joinAPI
        
        joinAPI.getPrejoin(userId: user.uid).subscribe {[weak self] prejoins in
            self?.preJoinList.accept(prejoins)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
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
        reload.onNext(())
    }
}
