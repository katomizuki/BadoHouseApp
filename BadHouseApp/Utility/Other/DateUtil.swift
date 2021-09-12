

import Foundation
import UIKit
//全部イベントのデータを取って来る,1週間以内のもの
class DateUtils {
    class func dateFromString(string: String, format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        let date = formatter.date(from: string)
        return date
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    class func getNow()->Date? {
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let datestring = dateFormatter.string(from: dt)
        print(datestring)
        let date = DateUtils.dateFromString(string: datestring, format: "yyyy/MM/dd HH:mm:ss Z")
        return date
    }
}
