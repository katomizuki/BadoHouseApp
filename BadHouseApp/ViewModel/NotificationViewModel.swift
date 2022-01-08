import RxSwift
import Foundation
import RxRelay

protocol NotificationViewModelInputs {
    func willAppear()
    func didTapCell(_ row: Int)
}
protocol NotificationViewModelOutputs {
    var notificationList:BehaviorRelay<[Notification]> { get }
    var errorHandling: PublishSubject<Error> { get }
    var reload: PublishSubject<Void> { get }
    var toPrejoined: PublishSubject<Void> { get }
    var toApplyedFriend: PublishSubject<Void> { get }
    var toUserDetail: PublishSubject<User> { get }
    var toPracticeDetail: PublishSubject<Practice> { get }
}
protocol NotificationViewModelType {
    var inputs: NotificationViewModelInputs { get }
    var outputs: NotificationViewModelOutputs { get }
}
final class NotificationViewModel: NotificationViewModelType, NotificationViewModelInputs, NotificationViewModelOutputs {
    var inputs: NotificationViewModelInputs { return self }
    var outputs: NotificationViewModelOutputs { return self }
    var reload = PublishSubject<Void>()
    var errorHandling = PublishSubject<Error>()
    var notificationList = BehaviorRelay<[Notification]>(value:[])
    var toPrejoined = PublishSubject<Void>()
    var toApplyedFriend = PublishSubject<Void>()
    var toUserDetail = PublishSubject<User>()
    var toPracticeDetail = PublishSubject<Practice>()
    let user: User
    let notificationAPI: NotificationServiceProtocol
    private let disposeBag = DisposeBag()
    init(user: User, notificationAPI: NotificationServiceProtocol) {
        self.user = user
        self.notificationAPI = notificationAPI
    }
    func willAppear() {
        notificationAPI.getMyNotification(uid: user.uid).subscribe { [weak self] notifications in
            self?.notificationList.accept(notifications)
        } onFailure: { [weak self] error in
            self?.errorHandling.onNext(error)
        }.disposed(by: disposeBag)
    }
    func didTapCell(_ row: Int) {
        let notification = self.notificationList.value[row]
        switch notification.notificationSelection {
        case .prejoined:
            self.toPrejoined.onNext(())
        case .applyed:
            self.toApplyedFriend.onNext(())
        case .permissionFriend:
            UserService.getUserById(uid: notification.id) { user in
                self.toUserDetail.onNext(user)
            }
        case .permissionJoin:
            print("ここ！",notification.id)
            PracticeServie.getPracticeById(id: notification.practiceId) { practice in
                print(practice,"あれ？")
                self.toPracticeDetail.onNext(practice)
            }
        }
    }
}
