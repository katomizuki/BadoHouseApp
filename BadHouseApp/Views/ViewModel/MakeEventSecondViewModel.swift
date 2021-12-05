import Foundation
import RxSwift

protocol MakeEventSecondViewModelInputs {
    
}
protocol MakeEventSecondViewModelOutputs {
    
}
protocol MakeEventSecondViewModelType {
    var inputs: MakeEventSecondViewModelInputs { get }
    var outputs: MakeEventSecondViewModelOutputs { get }
}
final class MakeEventSecondViewModel:MakeEventSecondViewModelType,MakeEventSecondViewModelOutputs,MakeEventSecondViewModelInputs {
    var inputs: MakeEventSecondViewModelInputs { return self }
    
    var outputs: MakeEventSecondViewModelOutputs { return self }
}
