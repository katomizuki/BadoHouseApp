//
//  SearchCircleViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import Foundation
protocol SearchCircleViewModelInputs {
    
}
protocol SearchCircleViewModelOutputs {
    
}
protocol SearchCircleViewModelType {
    var inputs:SearchCircleViewModelInputs { get }
    var outputs:SearchCircleViewModelOutputs { get }
}
final class SearchCircleViewModel: SearchCircleViewModelInputs,SearchCircleViewModelOutputs,SearchCircleViewModelType{
    var inputs: SearchCircleViewModelInputs { return self }
    var outputs: SearchCircleViewModelOutputs { return self }
}
