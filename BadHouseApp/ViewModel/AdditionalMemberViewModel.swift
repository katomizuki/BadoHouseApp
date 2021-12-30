//
//  AdditionalMemberViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/30.
//

import RxSwift
import RxRelay
protocol AdditionalMemberViewModelType {
    var inputs: AdditionalMemberViewModelInputs { get }
    var outputs: AdditionalMemberViewModelOutputs { get }
}
protocol AdditionalMemberViewModelInputs {
    func invite()
}
protocol AdditionalMemberViewModelOutputs {
    var friendsSubject:BehaviorRelay<[User]> { get }
    var isError:PublishSubject<Bool> { get }
    var completed:PublishSubject<Void> { get }
}
final class AdditionalMemberViewModel: AdditionalMemberViewModelType, AdditionalMemberViewModelInputs, AdditionalMemberViewModelOutputs {
    var inputs: AdditionalMemberViewModelInputs { return self }
    var outputs:AdditionalMemberViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var completed = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    lazy var inviteIds = circle.member
    var friendsSubject = BehaviorRelay<[User]>(value: [])
    var user: User
    var userAPI: UserServiceProtocol
    var circle: Circle
    init(user:User, userAPI: UserServiceProtocol,circle: Circle) {
        self.user = user
        self.userAPI = userAPI
        self.circle = circle
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            var array = [User]()
            for id in circle.member {
                users.forEach({
                    if $0.uid != id {
                        array.append($0)
                    }
                })
            }
            self?.friendsSubject.accept(array)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    func inviteAction(user: User?) {
        guard let user = user else {
            return
        }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    func invite() {
        CircleService.inviteCircle(ids: inviteIds, circle: circle) { result in
            switch result {
            case .success:
                self.completed.onNext(())
            case .failure:
                self.isError.onNext(true)
            }
        }
    }
}
