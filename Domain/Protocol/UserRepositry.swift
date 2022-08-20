//
//  UserRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol UserRepositry {
    func postUser(uid: String,
                  dic: [String: Any]) -> Completable
    func getUser(uid: String) ->Single<Domain.UserModel>
    func searchUser(text: String) ->Single<[Domain.UserModel]>
    func getFriends(uid: String) ->Single<[Domain.UserModel]>
    func getMyCircles(uid: String) -> Single<[Domain.CircleModel]>
    func getMyPractice(uid: String) -> Single<[Domain.Practice]>
    func judgeChatRoom(user: Domain.UserModel, myData: Domain.UserModel) -> Single<Bool>
    func postMyChatRoom(dic: [String: Any],
                        partnerDic: [String: Any],
                        user: Domain.UserModel,
                        myData: Domain.UserModel,
                        chatId: String)
    func getMyChatRooms(uid: String) -> Single<[Domain.ChatRoom]>
    func getUserChatRoomById(myData: Domain.UserModel,
                             id: String,
                             completion: @escaping(ChatRoom) -> Void)
    func updateChatRoom(user: Domain.UserModel,
                        myData: Domain.UserModel,
                        message: String)
    func getMyJoinPractice(user: Domain.UserModel) -> Single<[Practice]>
}
