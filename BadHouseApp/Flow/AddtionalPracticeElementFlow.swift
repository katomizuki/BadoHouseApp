//
//  AddtionalPracticeElementFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import UIKit
import Domain

protocol AddtionalPracticeElementFlow {
    func toNext(image: UIImage,
                circle: Domain.CircleModel,
                user: Domain.UserModel,
                dic: [String: Any])
    func toAddtionalPlace()
}
