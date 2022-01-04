//
//  PreJoinedViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}
protocol PreJoinedViewModelInputs {
    
}
protocol PreJoinedViewModelOutputs {
    
}
final class PreJoinedViewModel:PreJoinedViewModelType,PreJoinedViewModelInputs,PreJoinedViewModelOutputs {
    
    var inputs: PreJoinedViewModelInputs { return self }
    var outputs: PreJoinedViewModelOutputs { return self }
    var joinAPI:JoinServiceProtocol
    
    init(joinAPI:JoinServiceProtocol) {
        self.joinAPI = joinAPI
    }
    
}
