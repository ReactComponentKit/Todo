//
//  DateFormatter.swift
//  TodoApp
//
//  Created by burt on 2022/02/15.
//

import Foundation

enum DateUtils {
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    static func dateToString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(_ str: String) -> Date {
        return dateFormatter.date(from: str) ?? Date()
    }
}
