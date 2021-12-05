import RxSwift

protocol MakeEventFirstViewModelInputs {
    
}
protocol MakeEventFirstViewModelOutputs {
    
}
protocol MakeEventFirstViewModelType {
    var inputs: MakeEventFirstViewModelInputs { get }
    var outputs: MakeEventFirstViewModelOutputs { get }
}

final class MakeEventFirstViewModel:MakeEventFirstViewModelType,MakeEventFirstViewModelInputs,MakeEventFirstViewModelOutputs {
    var inputs: MakeEventFirstViewModelInputs { return self }
    
    var outputs: MakeEventFirstViewModelOutputs { return self }
    
    
}
