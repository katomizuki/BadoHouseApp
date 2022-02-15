//
//  UserRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol UserRepositry {
    func postUser(uid: String,
                  dic: [String: Any],
                  completion: @escaping (Result<Void, Error>) -> Void)
    func getUser(uid: String) ->Single<User>
    func searchUser(text: String) ->Single<[User]>
    func getFriends(uid: String) ->Single<[User]>
    func getMyCircles(uid: String) -> Single<[Circle]>
    func getMyPractice(uid: String) -> Single<[Practice]>
    func judgeChatRoom(user: User, myData: User, completion: @escaping (Bool) -> Void)
    func postMyChatRoom(dic: [String: Any],
                        partnerDic: [String: Any],
                        user: User,
                        myData: User,
                        chatId: String)
    func getMyChatRooms(uid: String) -> Single<[ChatRoom]>
    func getUserChatRoomById(myData: User,
                             id: String,
                             completion: @escaping(ChatRoom) -> Void)
    func updateChatRoom(user: User, myData: User, message: String)
    func getMyJoinPractice(user: User) -> Single<[Practice]>
}
