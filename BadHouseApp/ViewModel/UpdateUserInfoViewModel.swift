//
//  UpdateUserInfoViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/22.
//

import RxSwift
import Firebase
import RxRelay
import UIKit
protocol UpdateUserInfoViewModelInputs {
    func saveUser()
    var textViewInputs: AnyObserver<String> { get }
    var nameTextFieldInputs: AnyObserver<String> { get }
    var racketTextFieldInputs: AnyObserver<String> { get }
    var playerTextFieldInputs: AnyObserver<String> { get }
}
protocol UpdateUserInfoViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var userSubject: PublishSubject<User> { get }
    var genderSubject: PublishSubject<String> { get }
    var badmintonTimeSubject: PublishSubject<String> { get }
    var placeSubject: PublishSubject<String> { get }
    var ageSubject: PublishSubject<String> { get }
    var levelSubject: PublishSubject<String> { get }
    var reload: PublishSubject<Void> { get }
    var isCompleted: PublishSubject<Void> { get }
    var textViewSubject: BehaviorSubject<String> { get }
    var nameTextFieldSubject: BehaviorSubject<String> { get }
    var rackeTextFieldSubject: BehaviorSubject<String> { get }
    var playerTextFieldSubject: BehaviorSubject<String> { get }
    var userImage: UIImage? { get }
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
    var user: User?
    var isError = PublishSubject<Bool>()
    var userSubject = PublishSubject<User>()
    var genderSubject = PublishSubject<String>()
    var badmintonTimeSubject = PublishSubject<String>()
    var levelSubject = PublishSubject<String>()
    var ageSubject = PublishSubject<String>()
    var placeSubject = PublishSubject<String>()
    var reload =  PublishSubject<Void>()
    var isCompleted = PublishSubject<Void>()
    var textViewSubject = BehaviorSubject<String>(value: "")
    var nameTextFieldSubject = BehaviorSubject<String>(value: "")
    var rackeTextFieldSubject = BehaviorSubject<String>(value: "")
    var playerTextFieldSubject = BehaviorSubject<String>(value: "")
    var userImage: UIImage?
    var isChangeImage = false
    var playerTextFieldInputs: AnyObserver<String> {
        return playerTextFieldSubject.asObserver()
    }
    var racketTextFieldInputs: AnyObserver<String> {
        return rackeTextFieldSubject.asObserver()
    }
    var nameTextFieldInputs: AnyObserver<String> {
        return nameTextFieldSubject.asObserver()
    }
    var textViewInputs: AnyObserver<String> {
        return textViewSubject.asObserver()
    }
    let userAPI: UserServiceProtocol
    init(userAPI: UserServiceProtocol) {
        self.userAPI = userAPI
        if let uid = AuthService.getUid() {
            userAPI.getUser(uid: uid).subscribe { [weak self] user in
                self?.user = user
                self?.userSubject.onNext(user)
                self?.reload.onNext(())
            } onFailure: { [weak self] _ in
                self?.isError.onNext(true)
            }.disposed(by: disposeBag)
        }
        
        playerTextFieldSubject.subscribe { [weak self] text in
            self?.user?.player = text
        }.disposed(by: disposeBag)
        
        textViewSubject.subscribe { [weak self] text in
            self?.user?.introduction = text
        }.disposed(by: disposeBag)
        
        rackeTextFieldSubject.subscribe { [weak self] text in
            self?.user?.racket = text
        }.disposed(by: disposeBag)
        
    }
    
    func saveUser() {
        guard let user = user else { return }
        var dic: [String:Any] = ["name": user.name,
                                "email": user.email,
                                "createdAt": user.createdAt,
                                "updatedAt": Timestamp(),
                                "introduction": user.introduction,
                                "profileImageUrl": user.profileImageUrlString,
                                "level": user.level,
                                "gender": user.gender,
                                "place": user.place,
                                "badmintonTime": user.badmintonTime,
                                "age": user.age,
                                "racket": user.racket,
                                 "player": user.player,
                                 "uid": user.uid]
        if isChangeImage {
            StorageService.downLoadImage(image: userImage!) { [weak self] result in
                switch result {
                case .success(let urlString):
                    dic["profileImageUrl"] = urlString
                    self?.postUser(dic: dic)
                case .failure:
                    self?.isError.onNext(true)
                }
            }
        } else {
           postUser(dic: dic)
        }
    }
    
    func postUser(dic: [String:Any]) {
        userAPI.postUser(uid: AuthService.getUid()!, dic: dic) {[weak self] result in
            switch result {
            case .success:
                self?.isCompleted.onNext(())
            case .failure:
                self?.isError.onNext(true)
            }
        }
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
    func changeUser(_ userInfoSelecition: UserInfoSelection,
                    text: String) {
        switch userInfoSelecition {
        case .level:
            user?.level = text
        case .gender:
            user?.gender = text
        case .badmintonTime:
            user?.badmintonTime = text
        case .place:
            user?.place = text
        case .age:
            user?.age = text
        }
        self.reload.onNext(())
    }
    
}
