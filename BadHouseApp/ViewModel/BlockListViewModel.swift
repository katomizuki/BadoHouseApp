import RxRelay
import RxSwift
import Foundation

protocol BlockListViewModelType {
    var inputs: BlockListViewModelInputs { get }
    var outputs: BlockListViewModelOutputs { get }
}

protocol BlockListViewModelInputs {
    func willAppear()
    func removeBlock(_ user: User)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol BlockListViewModelOutputs {
    var blockListRelay: BehaviorRelay<[User]> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

final class BlockListViewModel: BlockListViewModelType {
    
    var blockListRelay = BehaviorRelay<[User]>(value: [])
    
    private var blockIds: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.blocks)
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    var inputs: BlockListViewModelInputs { return self }
    var outputs: BlockListViewModelOutputs { return self }
    
}

extension BlockListViewModel: BlockListViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func willAppear() {
        let group = DispatchGroup()
        var blockUsers = [User]()
        blockIds.forEach {
            group.enter()
            UserRepositryImpl.getUserById(uid: $0) { user in
                defer { group.leave() }
                blockUsers.append(user)
            }
        }
        group.notify(queue: .main) {
            self.blockListRelay.accept(blockUsers)
            self.reloadInput.onNext(())
        }
    }
    
    func removeBlock(_ user: User) {
        blockIds.remove(value: user.uid)
        UserDefaultsRepositry.shared.saveToUserDefaults(element: blockIds, key: R.UserDefaultsKey.blocks)
        var list = blockListRelay.value
        list.remove(value: user)
        blockListRelay.accept(list)
        reloadInput.onNext(())
    }
}
extension BlockListViewModel: BlockListViewModelOutputs {
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}
