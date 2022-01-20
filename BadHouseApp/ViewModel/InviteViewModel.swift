//
//  InviteViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/19.
//

import RxSwift
import RxRelay
protocol InviteViewModelInputs {
    func willAppear()
}
protocol InviteViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var friendsList: BehaviorRelay<[User]> { get }
    var isCompleted: PublishSubject<Void> { get }
}
protocol InviteViewModelType {
    var inputs: InviteViewModelInputs { get  }
    var outputs: InviteViewModelOutputs { get }
}
final class InviteViewModel: InviteViewModelType,
                                InviteViewModelInputs,
                            InviteViewModelOutputs {
    var isError = PublishSubject<Bool>()
    var isCompleted = PublishSubject<Void>()
    var friendsList = BehaviorRelay<[User]>(value: [])
    var inputs: InviteViewModelInputs { return self }
    var outputs: InviteViewModelOutputs { return self }
    var userAPI: UserServiceProtocol
    var user: User
    var form: Form
    var inviteIds = [String]()
    private let disposeBag = DisposeBag()
    private var dic = [String : Any]()
    let circleAPI: CircleServiceProtocol
    init(userAPI: UserServiceProtocol, user: User, form: Form,circleAPI: CircleServiceProtocol) {
        self.userAPI = userAPI
        self.user = user
        self.form = form
        self.circleAPI = circleAPI
        userAPI.getFriends(uid: user.uid).subscribe {[weak self] users in
            self?.friendsList.accept(users)
        } onFailure: {[weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
        
    }
    
    func willAppear() {
        let id = Ref.CircleRef.document().documentID
        dic = ["id": id,
                   "name": form.name,
                   "price": form.price,
                   "place": form.place,
                   "time": form.time,
               "features": form.features,
               "additionlText":form.additionlText]
        setupBackGroundImage()
        setupIconImage()
    }
    
    func setupBackGroundImage() {
        if let image = form.background {
            StorageService.downLoadImage(image: image) { result in
                switch result {
                case .success(let urlString):
                    self.dic["backGround"] = urlString
                case .failure:
                    self.isError.onNext(true)
                }
            }
        } else {
            dic["backGround"] = ""
        }
    }
    
    func setupIconImage() {
        if let icon = self.form.icon {
            StorageService.downLoadImage(image: icon) { result in
                switch result {
                case .success(let urlString):
                    self.dic["icon"] = urlString
                case .failure:
                    self.isError.onNext(true)
                }
            }
        } else {
            dic["icon"] = ""
        }
    }
    
    func inviteAction(user: User?) {
        guard let user = user else {
            return
        }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    
    func makeCircle() {
        inviteIds.append(user.uid)
        dic["member"] = inviteIds
        circleAPI.postCircle(id: dic["id"] as? String ?? "",
                                 dic: dic,
                                 user: user,
                                 memberId: inviteIds) { [weak self] result in
            switch result {
            case .success:
                self?.isCompleted.onNext(())
            case .failure:
                self?.isError.onNext(true)
            }
        }
        
    }
}
