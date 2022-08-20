//
//  HomeFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import UIKit
import Domain

protocol HomeFlow: AnyObject {
    func toMap(practices: [Domain.Practice],
               lat: Double,
               lon: Double,
               myData: Domain.UserModel?)
    func toMakeEvent()
    func toDetailSearch(_ vc: HomeViewController,
                        practices: [Domain.Practice])
    func toPracticeDetail(_ practice: Domain.Practice,
                          myData: Domain.UserModel?)
    func toAuthentication(_ vc: UIViewController)
}
