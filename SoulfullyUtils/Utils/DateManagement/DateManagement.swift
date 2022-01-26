//
//  DateManagement.swift
//  ServicePlatform
//
//
import Foundation
import SwiftDate

// swiftlint:disable identifier_name
public extension String {
    
    func date(format: String) throws -> Date {
        if let dateInRegion = DateInRegion(self, format: format, region: .local) {
            return dateInRegion.date
        }
        return Date.today
    }
    func toTime() -> Date {
        if let date = try? self.date(format: DateFormFormat.time.format) {
            return date
        }
        return Date.today
    }
    
    func toDate() -> Date {
        if let date = try? self.date(format: DateFormFormat.standard.format) {
            return date
        }
        return Date.today
    }
    
    func toDateOnly() -> String {
        if let date = try? self.date(format: DateFormFormat.dateOnly.format).toDateOnly() {
            return date
        }
        return self
    }
    
    func toUTC() -> String {
        if let dateInRegion = DateInRegion(self, format: DateFormFormat.standard.format, region: .local) {
            return dateInRegion.convertTo(region: .UTC).toString(.custom(DateFormFormat.standard.format))
        }
        return self
    }
    
    func toDateFromUTC(format: String = DateFormFormat.standard.format) -> Date {
        if let date = DateInRegion(self, format: format, region: .UTC) {
            return date.convertTo(region: .local).date
        }
        return Date.today
    }
    
    func toDateString(format: String = DateFormFormat.standard.format) -> String {
        if let date = try? self.date(format: format).toStandardDateString() {
            return date
        }
        return self
    }
    
    func diff() -> Int? {
        let today = Date.today
        let date = self.toDateFromUTC()
        return (today - date).in(.minute)
    }
    
    func combineTime(end: String) -> String {
        let date = self.toDateFromUTC()
        let endStr = end.isEmpty ? "": " - " + end.toDateFromUTC().toTimeString()
        let time = date.toTimeString() + endStr
        return date.toDateOnly() + " " + time
    }
    
    func comparasion(_ f: (Date, Date) -> Bool, target: String) -> Bool {
        return f(self.toDateFromUTC(), target.toDateFromUTC())
    }
    
    func isTomorrow(end: String) -> String {
        let verifiedDate = end.toDate()
        let current = self.toDate()
        if !current.isSameDay(from: verifiedDate) {
            return end
        }
        if verifiedDate < self.toDate() {
            return (verifiedDate + 1.days).toDateString()
        }
        return end
    }
    
    var isExpired: Bool {
        if self.isEmpty {
            return false
        }
        return self.toDateFromUTC().isBeforeDate(Date.today, granularity: .day)
    }
}

// MARK: - Date
public extension Date {
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    func roundUp() -> Date {
        var date = DateInRegion(self)
        if let minute = date.dateComponents.minute, minute > 0 {
                // swiftlint:disable shorthand_operator
            date = date + (60 - minute).minutes
        }
        return date.date
    }
    
    private func dateInRegion() -> DateInRegion {
        return DateInRegion(self, region: .local)
    }
    
    private func dateInRegion(format: String) -> DateInRegion {
        return DateInRegion(self, region: .local)
    }
    
    func format(_ format: String) -> String {
        return dateInRegion().toString(.custom(format))
    }
    
    func toTimeString() -> String {
        return self.format(DateFormFormat.time.format)
    }
    
    func toDateString() -> String {
        return self.format(DateFormFormat.date.format)
    }
    
    func toStandardDateString() -> String {
        return self.format(DateFormFormat.standard.format)
    }
    
    func toDateInYearString() -> String {
        return self.format(DateFormFormat.dateInYear.format)
    }
    
    func toShortDateString() -> String {
        return self.format(DateFormFormat.sortDate.format)
    }
    
    func toAbbMonthString() -> String {
        return self.format(DateFormFormat.abbMonth.format)
    }
    
    func toTimeStringExt() -> String {
        return self.format(DateFormFormat.time.format).lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    func toDateOnly() -> String {
        return self.format(DateFormFormat.dateOnly.format)
    }
    
    func weekdayMonthFormat() -> String {
        return self.format(DateFormFormat.weekdayInMonth.format)
    }
    
    func shortMonthDayFormat() -> String {
        return self.format(DateFormFormat.shortMonthDayOnly.format)
    }
    
    func monthFormat() -> String {
        return self.format(DateFormFormat.dateInMonth.format)
    }
    
    func weekdayFormat() -> String {
        return self.format(DateFormFormat.weekday.format)
    }
    
    func timeAndDateFormat() -> String {
        return self.format(DateFormFormat.timeAndDate.format)
    }
    
    static var today: Date {
        return DateInRegion().date
    }
    
    func dateUTC() -> String {
        let dateInRegion = DateInRegion(self, region: .local)
        return dateInRegion.convertTo(region: .UTC).toString(.custom(DateFormFormat.sortDate.format))
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
    
    /// Check the interval of self and inputting date is less than a specific detail second(10) or not
    func lessThanDelta(_ delta: Int, date: Date) -> Bool {
        guard let interval = (self - date).in(.second) else { return false }
        return interval < delta
    }
    
    /// Return short date format
    /// Ex: 6:10am, Yesterday, Monday, June 1
    func toShortDateFormat() -> String {
        if self.isToday {     return self.toTimeStringExt() }
        if self.isYesterday { return Terms.yesterday.desc }
        
        let today = Date.today
        let check = self.weekday >= firstDayOfWeek
        && self.weekday <= lastDayOfWeek
        && today.weekday >= firstDayOfWeek
        && today.weekday <= lastDayOfWeek
        if check { return weekdayName(.default) }
        return shortMonthDayFormat()
    }
    
    /// Returns true if they're same minute
    func isSameMinute(from date: Date?) -> Bool {
        if let date = date {
            return Calendar.current.compare(date, to: self, toGranularity: .minute) == .orderedSame
        }
        return false
    }
    
    func isSameDay(from date: Date?) -> Bool {
        if let date = date {
            return Calendar.current.compare(date, to: self, toGranularity: .day) == .orderedSame
        }
        return false
    }
    
    // Ex: Today, Yesterday, Monday, June 1
    func toDateWithSortFormat() -> String {
        if isToday {     return Terms.today.desc }
        if isYesterday { return Terms.yesterday.desc }
        
        let today = Date.today.weekday
        let check = self.weekday >= firstDayOfWeek
        && self.weekday <= lastDayOfWeek
        && today >= firstDayOfWeek && today <= lastDayOfWeek
        let result = self.toDateOnly()
        if check { return weekdayName(.default)  }
        return result
    }
    
    // 1 day = 86400s
    var AWSTimestamp: Int {
        return Int(timeIntervalSince1970*1000)
    }
}
