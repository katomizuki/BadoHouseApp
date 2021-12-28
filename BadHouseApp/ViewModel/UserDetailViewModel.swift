//
//  UserDetailViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/27.
//

import RxSwift

protocol UserDetailViewModelInputs {
    
}
protocol UserDetailViewModelOutputs {
    
}
protocol UserDetailViewModelType {
    var inputs:UserDetailViewModelInputs { get }
    var outputs:UserDetailViewModelOutputs { get }
}
final class UserDetailViewModel:UserDetailViewModelType, UserDetailViewModelInputs, UserDetailViewModelOutputs {
    var inputs: UserDetailViewModelInputs { return self }
    var outputs:UserDetailViewModelOutputs { return self }
}
