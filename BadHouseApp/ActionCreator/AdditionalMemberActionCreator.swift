//
//  AdditionalMemberActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//

import ReSwift
import RxSwift

struct AdditionalMemberActionCreator {

    let userAPI: UserRepositry
    let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    
    func getFriends(uid: String, members: [User]) {
        userAPI.getFriends(uid: uid).subscribe { friends in
            let users = self.judgeInviter(members: members, friends: friends)
            appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.setMember(users))
        } onFailure: { _ in
            appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func invite(ids: [String], circle: Circle) {
        circleAPI.inviteCircle(ids: ids, circle: circle) { result in
            switch result {
            case .success:
                appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeCompledStatus(true))
            case .failure:
                appStore.dispatch(AdditionalMemberState.AdditionalMemberAction.changeErrorStatus(true))
            }
        }
    }
    
    private func judgeInviter(members: [User], friends: [User]) -> [User] {
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
