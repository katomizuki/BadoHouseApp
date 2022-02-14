//
//  HomeFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import UIKit
protocol HomeFlow: AnyObject {
    func toMap(practices: [Practice], lat: Double, lon: Double)
    func toMakeEvent()
    func toDetailSearch(_ vc: HomeViewController, practices: [Practice])
    func toPracticeDetail(_ practice: Practice)
    func toAuthentication(_ vc: UIViewController)
}
