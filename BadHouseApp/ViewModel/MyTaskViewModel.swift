//
//  MyTaskViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/13.
//

import RxSwift
protocol MyTaskViewModelInput {
    
}
protocol MyTaskViewModelOutput {
    
}
protocol MyTaskViewModelType {
    var inputs: MyTaskViewModelInput { get }
    var outputs: MyTaskViewModelOutput { get }
}

final class MyTaskViewModel: MyTaskViewModelInput, MyTaskViewModelOutput, MyTaskViewModelType {
    var inputs: MyTaskViewModelInput { return self }
    var outputs: MyTaskViewModelOutput { return self }
    
    init() {
        
    }
}
