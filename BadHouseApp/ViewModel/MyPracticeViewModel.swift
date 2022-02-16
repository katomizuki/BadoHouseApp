import RxSwift
import RxRelay

protocol MyPracticeViewModelType {
    var inputs: MyPracticeViewModelInputs { get }
    var outputs: MyPracticeViewModelOutputs { get }
}

protocol MyPracticeViewModelInputs {
    func deletePractice(_ practice: Practice)
    var errorInput: AnyObserver<Bool> { get }
}

protocol MyPracticeViewModelOutputs {
    var practices: BehaviorRelay<[Practice]> { get }
    var isError: Observable<Bool> { get }
}

final class MyPracticeViewModel: MyPracticeViewModelType {
    
    var inputs: MyPracticeViewModelInputs { return self }
    var outputs: MyPracticeViewModelOutputs { return self }
    
    var practices = BehaviorRelay<[Practice]>(value: [])
    let user: User
    private let userAPI: UserRepositry
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    
    
    init(user: User, userAPI: UserRepositry) {
        self.user = user
        self.userAPI = userAPI
        userAPI.getMyPractice(uid: user.uid).subscribe { [weak self] practices in
            self?.practices.accept(practices)
        } onFailure: {[weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func deletePractice(_ practice: Practice) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users, documentId: user.uid, subCollectionName: R.Collection.Practice, subId: practice.id)
        DeleteService.deleteCollectionData(collectionName: R.Collection.Practice, documentId: practice.id)
    }
}

extension MyPracticeViewModel: MyPracticeViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
}
extension MyPracticeViewModel: MyPracticeViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}
