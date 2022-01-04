//
//  PreJoinViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//
protocol PreJoinViewModelType {
    
}
protocol PreJoinViewModelInputs {
    
}
protocol PreJoinViewModelOutputs {
    
}
final class PreJoinViewModel:PreJoinViewModelType, PreJoinViewModelInputs, PreJoinViewModelOutputs {
    var joinAPI:JoinServiceProtocol
    init(joinAPI:JoinServiceProtocol) {
        self.joinAPI = joinAPI
    }
}
