//
//  ApplyFriendsViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import RxSwift
import FirebaseAuth
import RxRelay
protocol ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { get }
    var outputs: ApplyFriendsViewModelOutputs { get }
}
protocol ApplyFriendsViewModelInputs {
    func onTrashButton(apply: Apply)
}
protocol ApplyFriendsViewModelOutputs {
    var applySubject: BehaviorRelay<[Apply]> { get }
    var isError: PublishSubject<Bool> { get }
    var reload: PublishSubject<Void> { get }
}

final class ApplyFriendsViewModel: ApplyFriendsViewModelInputs, ApplyFriendsViewModelOutputs, ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { return self }
    var outputs: ApplyFriendsViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var applySubject = BehaviorRelay<[Apply]>(value: [])
    var reload = PublishSubject<Void>()
    var user: User
    var applyAPI: ApplyServiceProtocol
    private let disposeBag = DisposeBag()
    init(user: User, applyAPI: ApplyServiceProtocol) {
        self.user = user
        self.applyAPI = applyAPI
        applyAPI.getApplyUser(user: user).subscribe {[weak self] apply in
            self?.applySubject.accept(apply)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    func onTrashButton(apply: Apply) {
            ApplyService.notApplyFriend(uid: self.user.uid, toUserId: apply.toUserId)
        let value = applySubject.value.filter {
            $0.toUserId != apply.toUserId
        }
        applySubject.accept(value)
        reload.onNext(())
    }
    
}
