//
//  DateExtension.swift
//  BeeWell
//
//  Created by Furkan Doğan on 17.12.2024.
//

import Foundation

extension Date {
    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
    
    func toCSTTime() -> Date {
        return self.addingTimeInterval(-21600)
    }
    
    func toUTC3Time() -> Date {
        return self.addingTimeInterval(21600)
    }
    
    func getDatesOf7Days() -> [Date] {
        let today = Calendar.current.startOfDay(for: Date())
        var dates = [Date]()
        for i in 0...6 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
            if let date {
                dates.append(date)
            }
        }
        return dates
    }
}
