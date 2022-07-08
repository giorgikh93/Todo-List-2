//
//  extensions.swift
//  Todo-List-2
//
//  Created by giorgi on 26.06.22.
//

import Foundation
let defaultFormat = "dd MMMM, y"
extension String {
    func toDate(format:String = defaultFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
}

extension Date {
    func toString(format: String = defaultFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
         calendar.isDate(self, equalTo: date, toGranularity: component)
     }

     func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
     func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
     func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

     func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

     var isInThisYear:  Bool { isInSameYear(as: Date()) }
     var isInThisMonth: Bool { isInSameMonth(as: Date()) }
     var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

     var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
     var isInToday:     Bool { Calendar.current.isDateInToday(self) }
     var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

     var isInTheFuture: Bool { self > Date() }
     var isInThePast:   Bool { self < Date() }
}

extension Dictionary where Key == String{
    func sortedKeys() -> [String] {
        return self.keys.sorted(by:  { $0.toDate() < $1.toDate() })
    }
     
}
