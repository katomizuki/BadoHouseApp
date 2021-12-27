//
//  UpdateUserInfoViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/22.
//

import RxSwift
protocol UpdateUserInfoViewModelInputs {
    func willAppear()
}
protocol UpdateUserInfoViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var userSubject: PublishSubject<User> { get }
}
protocol UpdateUserInfoViewModelType {
    var inputs: UpdateUserInfoViewModelInputs { get }
    var outputs: UpdateUserInfoViewModelOutputs { get }
}

final class UpdateUserInfoViewModel: UpdateUserInfoViewModelType,
                                     UpdateUserInfoViewModelOutputs,
                                     UpdateUserInfoViewModelInputs {
    var inputs: UpdateUserInfoViewModelInputs { return self }
    var outputs: UpdateUserInfoViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    var user:User?
    var isError = PublishSubject<Bool>()
    var userSubject = PublishSubject<User>()
    let userAPI: UserServiceProtocol
    init(userAPI: UserServiceProtocol) {
        self.userAPI = userAPI
        if let uid = UserService.getUid() {
            userAPI.getUser(uid: uid).subscribe { [weak self] user in
                self?.user = user
                self?.userSubject.onNext(user)
            } onFailure: { [weak self] _ in
                self?.isError.onNext(true)
            }.disposed(by: disposeBag)
        }
    }
    
    func willAppear() {
        
    }
    func getUserData(_ selection:UserInfoSelection) -> String {
        guard let user = user else {
            return "未設定"
        }
        switch selection {
        case .level:
            return user.level
        case .gender:
            return user.gender
        case .badmintonTime:
            return user.badmintonTime
        case .place:
            return user.place
        case .age:
            return user.age
        }
    }
    
}
