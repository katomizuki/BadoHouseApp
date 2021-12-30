//
//  UserDetailViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/27.
//

import RxSwift
import RxRelay

protocol UserDetailViewModelInputs {
    func willAppear()
}
protocol UserDetailViewModelOutputs {
    var isError:PublishSubject<Bool> { get }
    var friendListRelay:BehaviorRelay<[User]> { get }
    var circleListRelay:BehaviorRelay<[Circle]> { get }
    var reload: PublishSubject<Void> { get }
}
protocol UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { get }
    var outputs: UserDetailViewModelOutputs { get }
}
final class UserDetailViewModel: UserDetailViewModelType, UserDetailViewModelInputs, UserDetailViewModelOutputs {
    var inputs: UserDetailViewModelInputs { return self }
    var outputs: UserDetailViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var friendListRelay = BehaviorRelay<[User]>(value: [])
    var circleListRelay = BehaviorRelay<[Circle]>(value: [])
    var reload = PublishSubject<Void>()
    var user: User
    var myData: User
    var userAPI: UserServiceProtocol
    private let disposeBag = DisposeBag()
    init(myData: User, user: User, userAPI: UserServiceProtocol) {
        self.user = user
        self.myData = myData
        self.userAPI = userAPI
    }
    
    func willAppear() {
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            self?.friendListRelay.accept(users)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)

        userAPI.getMyCircles(uid: user.uid).subscribe { [weak self] circles in
            self?.circleListRelay.accept(circles)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)

    
    }
}
