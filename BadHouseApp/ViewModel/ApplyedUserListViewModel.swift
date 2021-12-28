import RxSwift
import RxRelay

protocol ApplyedUserListViewModelInputs {
    func willAppear()
    func makeFriends(_ applyed: Applyed)
}
protocol ApplyedUserListViewModelOutputs {
    var applyedSubject: BehaviorRelay<[Applyed]> { get }
    var isError: PublishSubject<Bool> { get }
    var reload: PublishSubject<Void> { get }
}
protocol ApplyedUserListViewModelType {
    var inputs: ApplyedUserListViewModelInputs { get }
    var outputs: ApplyedUserListViewModelOutputs { get }
}
final class  ApplyedUserListViewModel: ApplyedUserListViewModelType, ApplyedUserListViewModelInputs,ApplyedUserListViewModelOutputs {
    
    var inputs: ApplyedUserListViewModelInputs { return self }
    var outputs: ApplyedUserListViewModelOutputs { return self }
    var applyedSubject = BehaviorRelay<[Applyed]>(value: [])
    private let disposeBag = DisposeBag()
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var applyAPI: ApplyServiceProtocol
    var user: User
    init(applyAPI: ApplyServiceProtocol, user: User) {
        self.applyAPI = applyAPI
        self.user = user
    }
    func willAppear() {
        applyAPI.getApplyedUser(user: user)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] applyeds in
            self?.applyedSubject.accept(applyeds)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    func makeFriends(_ applyed: Applyed) {
        // 消してあげてマッチのところに入れてあげる。
        DeleteService.deleteCollectionData(collectionName: "Applyed", documentId: applyed.uid)
        DeleteService.deleteCollectionData(collectionName: "Apply", documentId: user.uid)
        
    }
}
