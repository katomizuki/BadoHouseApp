//
//  UserFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import UIKit
import Domain

protocol UserFlow: AnyObject {
    func toSearchCircle(user: Domain.UserModel?)
    func toMyPage(_ vc: UIViewController)
    func toSearchUser(user: Domain.UserModel?)
    func toDetailUser(myData: Domain.UserModel?,
                      user: Domain.UserModel?)
    func toDetailCircle(myData: Domain.UserModel?,
                        circle: Domain.CircleModel?)
    func toMakeCircle(user: Domain.UserModel?)
    func toSettings(_ vc: UIViewController,
                    user: Domain.UserModel?)
    func toSchedule(_ vc: UIViewController,
                    user: Domain.UserModel?)
    func toApplyUser(user: Domain.UserModel?)
    func toApplyedUser(user: Domain.UserModel?)
    func toTodo()
}
