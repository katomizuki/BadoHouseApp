import RxSwift
import Foundation

protocol UserViewModelInputs {
    
}
protocol UserViewModelOutputs {
    
}
protocol UserViewModelType {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}
final class UserViewModel:UserViewModelType,UserViewModelInputs,UserViewModelOutputs {
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
}
