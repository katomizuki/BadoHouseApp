//
//  UIView+Extension.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
extension UIView {
    func changeCorner(num:Int) {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(num)
    }
}
