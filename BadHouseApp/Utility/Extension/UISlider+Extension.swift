//
//  UISlider+Extension.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//

import UIKit
extension UISlider {
    func getLevelText(_ level:Double) -> String {
        var message = String()
        if case 0..<0.1 = level {
            message = BadmintonLevel(rawValue: 0)!.description
        }
        if case 0.1..<0.2 = level {
            message = BadmintonLevel(rawValue: 1)!.description
        }
        if case 0.2..<0.3 = level {
            message = BadmintonLevel(rawValue: 2)!.description
        }
        if case 0.3..<0.4 = level {
            message = BadmintonLevel(rawValue: 3)!.description
        }
        if case 0.4..<0.5 = level {
            message = BadmintonLevel(rawValue: 4)!.description
        }
        if case 0.5..<0.6 = level {
            message = BadmintonLevel(rawValue: 5)!.description
        }
        if case 0.6..<0.7 = level {
            message = BadmintonLevel(rawValue: 6)!.description
        }
        if case 0.7..<0.8 = level {
            message = BadmintonLevel(rawValue: 7)!.description
        }
        if case 0.8..<0.9 = level {
            message = BadmintonLevel(rawValue: 8)!.description
        }
        if case 0.9..<1.0 = level {
            message = BadmintonLevel(rawValue: 9)!.description
        }
        return message
    }
    func getLevelSentence(_ level:Double) -> String {
        var text = String()
        if case 0..<0.1 = level {
            text = R.array.levelSentence[0]
        }
        if case 0.1..<0.2 = level {
            text = R.array.levelSentence[1]
        }
        if case 0.2..<0.3 = level {
            text = R.array.levelSentence[2]
        }
        if case 0.3..<0.4 = level {
            text = R.array.levelSentence[3]
        }
        if case 0.4..<0.5 = level {
            text = R.array.levelSentence[4]
        }
        if case 0.5..<0.6 = level {
            text = R.array.levelSentence[5]
        }
        if case 0.6..<0.7 = level {
            text = R.array.levelSentence[6]
        }
        if case 0.7..<0.8 = level {
            text = R.array.levelSentence[7]
        }
        if case 0.8..<0.9 = level {
            text = R.array.levelSentence[8]
        }
        if case 0.9..<1.0 = level {
            text = R.array.levelSentence[9]
        }
        return text
    }
    
   
}
