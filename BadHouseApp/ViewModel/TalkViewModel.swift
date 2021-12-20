import RxSwift
import Foundation
protocol TalkViewModelInputs {
    
}
protocol TalkViewModelOutputs {
    
}
protocol TalkViewModelType {
    var inputs: TalkViewModelInputs { get }
    var outputs: TalkViewModelOutputs { get }
}
final class TalkViewModel:TalkViewModelType,TalkViewModelInputs,TalkViewModelOutputs {
    var inputs: TalkViewModelInputs { return self }
    var outputs: TalkViewModelOutputs { return self }
 
}
