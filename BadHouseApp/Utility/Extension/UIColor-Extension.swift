import Foundation
import UIKit
//Mark:UIColor-Extension
extension UIColor {
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1)->UIColor {
        return .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
