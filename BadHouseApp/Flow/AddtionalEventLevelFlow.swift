//
//  AddtionalEventLevelFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import UIKit
import Domain

protocol AddtionalEventLevelFlow {
    func toNext(image: UIImage,
                dic: [String: Any],
                circle: Domain.CircleModel,
                user: Domain.UserModel)
}
