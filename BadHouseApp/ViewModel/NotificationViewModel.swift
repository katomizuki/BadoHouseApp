import RxSwift
import Foundation

protocol NotificationViewModelInputs {
    
}
protocol NotificationViewModelOutputs {
    
}
protocol NotificationViewModelType {
    var inputs: NotificationViewModelInputs { get }
    var outputs: NotificationViewModelOutputs { get }
}
final class NotificationViewModel: NotificationViewModelType,NotificationViewModelInputs,NotificationViewModelOutputs {
    var inputs: NotificationViewModelInputs { return self }
    var outputs: NotificationViewModelOutputs { return self }
    
    
}
