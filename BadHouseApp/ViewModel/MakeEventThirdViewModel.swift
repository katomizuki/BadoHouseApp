import RxSwift
import Foundation
protocol MakeEventThirdViewModelInputs {
    
}
protocol MakeEventThirdViewModelOutputs {
    
}
protocol MakeEventThirdViewModelType {
    var inputs: MakeEventThirdViewModelInputs { get }
    var outputs: MakeEventThirdViewModelOutputs { get }
}
final class MakeEventThirdViewModel:MakeEventThirdViewModelInputs,MakeEventThirdViewModelOutputs,MakeEventThirdViewModelType {
    var inputs: MakeEventThirdViewModelInputs { return self }
    var outputs: MakeEventThirdViewModelOutputs { return self }
}
