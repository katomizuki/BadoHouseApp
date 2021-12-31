//
//  BlockListViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/31.
//

import RxRelay
import RxSwift
protocol BlockListViewModelType {
    var inputs: BlockListViewModelInputs { get }
    var outputs: BlockListViewModelOutputs { get }
}
protocol BlockListViewModelInputs {
    func willAppear()
    func removeBlock(_ user:User)
}
protocol BlockListViewModelOutputs {
    var blockListRelay: BehaviorRelay<[User]> { get }
    var isError: PublishSubject<Bool> { get }
    var reload: PublishSubject<Void> { get }
}
final class BlockListViewModel:BlockListViewModelInputs, BlockListViewModelOutputs, BlockListViewModelType {
    var reload = PublishSubject<Void>()
    var blockListRelay = BehaviorRelay<[User]>(value: [])
    var isError = PublishSubject<Bool>()
    private var blockIds: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "blocks")
    var inputs: BlockListViewModelInputs { return self }
    var outputs: BlockListViewModelOutputs { return self }
    func willAppear() {
        print(blockIds)
        let group = DispatchGroup()
        var blockUsers = [User]()
        blockIds.forEach {
            group.enter()
            UserService.getUserById(uid: $0) { user in
                defer { group.leave() }
                blockUsers.append(user)
            }
        }
        group.notify(queue: .main) {
            self.blockListRelay.accept(blockUsers)
            self.reload.onNext(())
        }
    }
    func removeBlock(_ user: User) {
        blockIds.remove(value: user.uid)
        UserDefaultsRepositry.shared.saveToUserDefaults(element: blockIds, key: "blocks")
        var list = blockListRelay.value
        list.remove(value: user)
        blockListRelay.accept(list)
        reload.onNext(())
    }
}
