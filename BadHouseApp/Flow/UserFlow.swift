//
//  UserFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import UIKit

protocol UserFlow: AnyObject {
    func toSearchCircle(user: User?)
    func toMyPage(_ vc: UIViewController)
    func toSearchUser(user: User?)
    func toDetailUser(myData: User?, user: User?)
    func toDetailCircle(myData: User?, circle: Circle?)
    func toMakeCircle(user: User?)
    func toSettings(_ vc: UIViewController, user: User?)
    func toSchedule(_ vc: UIViewController, user: User?)
    func toApplyUser(user: User?)
    func toApplyedUser(user: User?)
    func toTodo()
}
