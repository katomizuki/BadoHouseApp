//
//  AddtionalPracticeElementFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import UIKit
protocol AddtionalPracticeElementFlow {
    func toNext(image: UIImage,
                circle: Circle,
                user: User,
                dic: [String: Any])
    func toAddtionalPlace()
}
