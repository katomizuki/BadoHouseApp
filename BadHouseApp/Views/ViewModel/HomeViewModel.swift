import Foundation
import RxSwift
protocol HomeViewModelInputs {
    
}
protocol HomeViewModelOutputs {
    
}
protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}
final class HomeViewModel:HomeViewModelInputs,HomeViewModelOutputs,HomeViewModelType {
    var inputs: HomeViewModelInputs { return self }
    
    var outputs: HomeViewModelOutputs { return self }
}
