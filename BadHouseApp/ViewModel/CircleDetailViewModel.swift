import RxSwift
import RxRelay

protocol CircleDetailViewModelInputs {
    func changeMember(_ index: Int)
}

protocol CircleDetailViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var memberRelay: BehaviorRelay<[User]> { get }
    var reload: PublishSubject<Void> { get }
    var isRightButtonHidden: PublishSubject<Bool> { get }
}

protocol CircleDetailViewModelType {
    var inputs: CircleDetailViewModelInputs { get }
    var outputs: CircleDetailViewModelOutputs { get }
}

final class CircleDetailViewModel: CircleDetailViewModelInputs, CircleDetailViewModelOutputs, CircleDetailViewModelType {
    
    var inputs: CircleDetailViewModelInputs { return self }
    var outputs: CircleDetailViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var memberRelay = BehaviorRelay<[User]>(value: [])
    var reload = PublishSubject<Void>()
    var isRightButtonHidden = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    var circle: Circle
    var myData: User
    var allMembers = [User]()
    var friendsMembers = [User]()
    var genderPercentage = [Int]()
    var levelPercentage = [Int]()
    var circleAPI: CircleRepositry
    
    private let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
    
    init(myData: User, circle: Circle, circleAPI: CircleRepositry) {
        self.myData = myData
        self.circle = circle
        self.circleAPI = circleAPI
        circleAPI.getMembers(ids: circle.member, circle: circle).subscribe { [weak self] circle in
            guard let self = self else { return }
            self.allMembers = circle.members
            self.circle = circle
            self.friendsMembers = circle.members.filter({ user in
                self.ids.contains(user.uid)
            })
            self.getPercentage()
            self.checkRightButtonHidden(self.allMembers)
            self.memberRelay.accept(circle.members)
            self.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func changeMember(_ index: Int) {
        if index == 0 {
            memberRelay.accept(allMembers)
        } else {
            memberRelay.accept(friendsMembers)
        }
        reload.onNext(())
    }
    func getPercentage() {
        var (men, women, other) = (0, 0, 0)
        var (one, two, three, four, five, six, seven, eight, nine, ten) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        allMembers.forEach {
            switch $0.gender {
            case "男性":men += 1
            case "女性":women += 1
            default:other += 1
            }
            switch $0.level {
            case "レベル1":one += 1
            case "レベル2":two += 1
            case "レベル3":three += 1
            case "レベル4":four += 1
            case "レベル5":five += 1
            case "レベル6":six += 1
            case "レベル7": seven += 1
            case "レベル8":eight += 1
            case "レベル9":nine += 1
            case "レベル10":ten += 1
            default:break
            }
        }
        genderPercentage = [men, women, other]
        levelPercentage = [one, two, three, four, five, six, seven, eight, nine, ten]
    }
    
    private func checkRightButtonHidden(_ users: [User]) {
        var isHidden = true
        users.forEach { user in
           if user.uid == myData.uid {
               isHidden = false
            }
        }
        self.isRightButtonHidden.onNext(isHidden)
    }
    
}
