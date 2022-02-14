//
//  AddtionalEventLevelFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import UIKit

protocol AddtionalEventLevelFlow {
    func toNext(image: UIImage,
                dic: [String: Any],
                circle: Circle,
                user: User)
}
