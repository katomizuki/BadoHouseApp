//
//  PreJoinViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//
import RxSwift
import RxRelay

protocol PreJoinViewModelType {
    var inputs: PreJoinViewModelInputs { get }
    var outputs: PreJoinViewModelOutputs { get }
}
protocol PreJoinViewModelInputs {
    
}
protocol PreJoinViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var preJoinList: BehaviorRelay<[PreJoin]> { get }
    var reload: PublishSubject<Void> { get }
}
final class PreJoinViewModel: PreJoinViewModelType, PreJoinViewModelInputs, PreJoinViewModelOutputs {
    var inputs: PreJoinViewModelInputs { return self }
    var outputs: PreJoinViewModelOutputs { return self }
    var joinAPI:JoinServiceProtocol
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var preJoinList =  BehaviorRelay<[PreJoin]>(value:[])
    private let disposeBag = DisposeBag()
    init(joinAPI:JoinServiceProtocol,user: User) {
        self.joinAPI = joinAPI
        
        joinAPI.getPrejoin(userId: user.uid).subscribe {[weak self] prejoins in
            self?.preJoinList.accept(prejoins)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
}
