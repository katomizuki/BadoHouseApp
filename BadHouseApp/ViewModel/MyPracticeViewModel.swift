import RxSwift
import RxRelay

protocol MyPracticeViewModelType {
    var inputs: MyPracticeViewModelInputs { get }
    var outputs: MyPracticeViewModelOutputs { get }
}

protocol MyPracticeViewModelInputs {
    func deletePractice(_ practice: Practice)
}

protocol MyPracticeViewModelOutputs {
    var practices: BehaviorRelay<[Practice]> { get }
    var isError: PublishSubject<Bool> { get }
}

final class MyPracticeViewModel: MyPracticeViewModelInputs, MyPracticeViewModelOutputs, MyPracticeViewModelType {
    
    var inputs: MyPracticeViewModelInputs { return self }
    var outputs: MyPracticeViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var practices = BehaviorRelay<[Practice]>(value: [])
    let user: User
    let userAPI: UserServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(user: User, userAPI: UserServiceProtocol) {
        self.user = user
        self.userAPI = userAPI
        userAPI.getMyPractice(uid: user.uid).subscribe { [weak self] practices in
            self?.practices.accept(practices)
        } onFailure: {[weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func deletePractice(_ practice: Practice) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users, documentId: user.uid, subCollectionName: R.Collection.Practice, subId: practice.id)
        DeleteService.deleteCollectionData(collectionName: R.Collection.Practice, documentId: practice.id)
    }
    
}
