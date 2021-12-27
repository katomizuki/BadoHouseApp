//
//  UpdateUserInfoViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/22.
//
protocol UpdateUserInfoViewModelInputs {
    
}
protocol UpdateUserInfoViewModelOutputs {
    
}
protocol UpdateUserInfoViewModelType {
    var inputs:UpdateUserInfoViewModelInputs { get }
    var outputs:UpdateUserInfoViewModelOutputs { get }
}

final class UpdateUserInfoViewModel: UpdateUserInfoViewModelType,
                                     UpdateUserInfoViewModelOutputs,
                                     UpdateUserInfoViewModelInputs {
    var inputs: UpdateUserInfoViewModelInputs { return self }
    var outputs: UpdateUserInfoViewModelOutputs { return self }
    
    
}
