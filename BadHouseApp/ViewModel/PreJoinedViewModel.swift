//
//  PreJoinedViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import RxRelay
import RxSwift
protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}
protocol PreJoinedViewModelInputs {
    func permission(_ preJoined: PreJoined)
}
protocol PreJoinedViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var preJoinedList: BehaviorRelay<[PreJoined]> { get }
    var reload: PublishSubject<Void> { get }
    var completed: PublishSubject<Void> { get }
}
final class PreJoinedViewModel:PreJoinedViewModelType,PreJoinedViewModelInputs, PreJoinedViewModelOutputs {
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var inputs: PreJoinedViewModelInputs { return self }
    var outputs: PreJoinedViewModelOutputs { return self }
    var joinAPI:JoinServiceProtocol
    var preJoinedList = BehaviorRelay<[PreJoined]>(value:[])
    private let disposeBag = DisposeBag()
    var completed = PublishSubject<Void>()
    init(joinAPI:JoinServiceProtocol,user: User) {
        self.joinAPI = joinAPI
        joinAPI.getPreJoined(userId: user.uid).subscribe {[weak self] prejoineds in
            self?.preJoinedList.accept(prejoineds)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func permission(_ preJoined: PreJoined) {
        DeleteService.deleteCollectionData(collectionName: "PreJoin", documentId: preJoined.fromUserId)
        DeleteService.deleteCollectionData(collectionName: "PreJoined", documentId: preJoined.uid)
        joinAPI.postMatchJoin(preJoined: preJoined) { error in
            if let error = error {
                self.isError.onNext(true)
            }
            self.completed.onNext(())
        }
    }

    
}
