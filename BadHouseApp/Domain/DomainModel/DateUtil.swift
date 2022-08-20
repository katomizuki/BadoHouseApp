//
//  DateUtil.swift
//  Domain
//
//  Created by ミズキ on 2022/08/19.
//

import Foundation

class DateUtils {
    
    static func dateFromString(string: String, format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        let date = formatter.date(from: string)
        return date
    }
    
    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func getNow() -> Date? {
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let datestring = dateFormatter.string(from: dt)
        let date = DateUtils.dateFromString(string: datestring, format: "yyyy/MM/dd HH:mm:ss Z")
        return date
    }
}
