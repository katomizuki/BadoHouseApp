//
//  InviteViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import RxSwift
protocol InviteViewModelInputs {
    
}
protocol InviteViewModelOutputs {
    
}
protocol InviteViewModelType {
    var inputs:InviteViewModelInputs { get  }
    var outputs:InviteViewModelOutputs { get }
}
final class InviteViewModel:InviteViewModelType,
                                InviteViewModelInputs,
                                InviteViewModelOutputs {
    var inputs: InviteViewModelInputs { return self }
    var outputs: InviteViewModelOutputs { return self }
}
