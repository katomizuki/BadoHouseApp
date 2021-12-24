//
//  TextField+Extension.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
extension UITextField {
    func setUnderLine(width:CGFloat) {
        borderStyle = .none
        let underLine = UIView()
        underLine.backgroundColor = .darkGray
        addSubview(underLine)
        underLine.anchor(bottom: bottomAnchor,
               leading: leadingAnchor,
               trailing: trailingAnchor,
               height: 1)
    }
}
