import RxRelay
import RxSwift
import FirebaseAuth
import UIKit

protocol PracticeDetailViewModelType {
    var inputs: PracticeDetailViewModelInputs { get }
    var outputs: PracticeDetailViewModelOutputs { get }
}

protocol PracticeDetailViewModelInputs {
    func takePartInPractice()
}

protocol PracticeDetailViewModelOutputs {
    var userRelay: PublishRelay<User> { get }
    var circleRelay: PublishRelay<Circle> { get }
    var isError: PublishSubject<Bool> { get }
    var isButtonHidden: PublishSubject<Bool> { get }
    var completed: PublishSubject<Void> { get }
    var isTakePartInButton: PublishSubject<Bool> { get }
}

final class PracticeDetailViewModel: PracticeDetailViewModelType, PracticeDetailViewModelInputs, PracticeDetailViewModelOutputs {

    var inputs: PracticeDetailViewModelInputs { return self }
    var outputs: PracticeDetailViewModelOutputs { return self }

    var userRelay = PublishRelay<User>()
    var circleRelay = PublishRelay<Circle>()
    var isButtonHidden = PublishSubject<Bool>()
    var isError = PublishSubject<Bool>()
    var completed = PublishSubject<Void>()
    var isTakePartInButton = PublishSubject<Bool>()
    let practice: Practice
    var myData: User?
    var circle: Circle?
    var user: User?
    
    private let userAPI: UserRepositry
    private let circleAPI: CircleRepositry
    private let joinAPI: JoinRepositry
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let buttonHiddenStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let takePartInButtonStream = PublishSubject<Bool>()
    let isModal: Bool
    
    init(practice: Practice,
         userAPI: UserRepositry,
         circleAPI: CircleRepositry,
         isModal: Bool, joinAPI: JoinRepositry) {
        self.practice = practice
        self.userAPI = userAPI
        self.circleAPI = circleAPI
        self.isModal = isModal
        self.joinAPI = joinAPI
        userAPI.getUser(uid: practice.userId).subscribe { [weak self] user in
            self?.userRelay.accept(user)
            self?.user = user
            
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
        
        circleAPI.getCircle(id: practice.circleId).subscribe {[weak self] circle in
            self?.circleRelay.accept(circle)
            self?.circle = circle
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserRepositryImpl.getUserById(uid: uid) { myData in
            self.myData = myData
            if myData.uid == self.user?.uid || self.isModal == true {
                self.isButtonHidden.onNext(true)
            }
        }
    }
    
    func takePartInPractice() {
        guard let user = user else { return }
        guard let myData = myData else { return }
        joinAPI.postPreJoin(user: myData, toUser: user, practice: practice).subscribe {
            self.completed.onNext(())
        } onError: { _ in
            self.isError.onNext(true)
        }.disposed(by: disposeBag)
        checkUserDefault()
    }
    
    private func checkUserDefault() {
        if UserDefaults.standard.object(forKey: R.UserDefaultsKey.preJoin) != nil {
            var array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.preJoin)
            array.append(practice.id)
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.preJoin)
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [practice.id], key: R.UserDefaultsKey.preJoin)
        }
    }
}
