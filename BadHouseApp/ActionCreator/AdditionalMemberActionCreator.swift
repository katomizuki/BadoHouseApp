//
//  AdditionalMemberActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//

import ReSwift
import RxSwift
import Domain

struct AdditionalMemberActionCreator {

    let userAPI: any UserRepositry
    let circleAPI: any CircleRepositry
    private let disposeBag = DisposeBag()
    
    func getFriends(uid: String,
                    members: [Domain.UserModel]) {
        userAPI.getFriends(uid: uid).subscribe { friends in
            let users = self.judgeInviter(members: members,
                                          friends: friends)
            appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.setMember(users))
        } onFailure: { _ in
            appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func invite(ids: [String],
                circle: Domain.CircleModel) {
        circleAPI.inviteCircle(ids: ids,
                               circle: circle) { result in
            switch result {
            case .success:
                appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeCompledStatus(true))
            case .failure:
                appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeErrorStatus(true))
            }
        }
    }
    
    private func judgeInviter(members: [Domain.UserModel],
                              friends: [Domain.UserModel]) -> [Domain.UserModel] {
        var array = friends
        members.forEach {
            array.remove(value: $0)
        }
        return array
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeErrorStatus(false))
    }
    
    func toggleCompletedStatus() {
        appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeCompledStatus(true))
    }
}
