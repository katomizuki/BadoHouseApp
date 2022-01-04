//
//  PracticeDetailViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

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
    var userRelay:PublishRelay<User> { get }
    var circleRelay: PublishRelay<Circle> { get }
    var isError: PublishSubject<Bool> { get }
    var isButtonHidden: PublishSubject<Bool> { get }
    var completed:PublishSubject<Void> { get }
}
final class PracticeDetailViewModel: PracticeDetailViewModelType, PracticeDetailViewModelInputs, PracticeDetailViewModelOutputs {
    var inputs: PracticeDetailViewModelInputs { return self }
    var outputs: PracticeDetailViewModelOutputs { return self }
    var userRelay = PublishRelay<User>()
    var circleRelay = PublishRelay<Circle>()
    var isButtonHidden = PublishSubject<Bool>()
    var isError = PublishSubject<Bool>()
    var completed = PublishSubject<Void>()
    let practice: Practice
    var myData: User?
    var circle: Circle?
    var user: User?
    let userAPI: UserServiceProtocol
    let circleAPI: CircleServiceProtocol
    private let disposeBag = DisposeBag()
    var isModal: Bool
    init(practice: Practice,
         userAPI: UserServiceProtocol,
         circleAPI: CircleServiceProtocol,
         isModal: Bool) {
        self.practice = practice
        self.userAPI = userAPI
        self.circleAPI = circleAPI
        self.isModal = isModal
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
        
        UserService.getUserById(uid: uid) { myData in
            self.myData = myData
            if myData.uid == self.user?.uid || self.isModal == true {
                self.isButtonHidden.onNext(true)
            }
        }
    }
    func takePartInPractice() {
        guard let user = user else {
            return
        }
        guard let myData = myData else {
            return
        }
        JoinService.postPreJoin(user: myData, toUser: user) { result in
            switch result {
            case .success:
                self.completed.onNext(())
            case .failure:
                self.isError.onNext(true)
            }
        }
        
    }
}
