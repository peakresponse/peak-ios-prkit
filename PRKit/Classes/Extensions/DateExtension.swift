//
//  DateExtension.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import Foundation

public extension Date {
    func asDateString() -> String {
        return DateFormatter.dateFormatter.string(from: self)
    }

    func asDateTimeString() -> String {
        return DateFormatter.dateTimeFormatter.string(from: self)
    }

    func asISO8601String() -> String {
        return ISO8601DateFormatter.string(from: self)!
    }

    func asISO8601DateString() -> String {
        let dateTimeString = ISO8601DateFormatter.string(from: self)!
        return String(dateTimeString[dateTimeString.startIndex..<dateTimeString.index(dateTimeString.startIndex, offsetBy: 10)])
    }

    func asLocalizedTime() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }

    func asRelativeString() -> String {
        if #available(iOS 13.0, *) {
            return RelativeDateTimeFormatter.localizedString(for: self)
        } else {
            return asTimeString()
        }
    }

    func asTimeDateString() -> String {
        return DateFormatter.timeDateFormatter.string(from: self)
    }

    func asTimeString() -> String {
        return DateFormatter.timeFormatter.string(from: self)
    }

    func dist(to other: Date) -> TimeInterval {
        if #available(iOS 13.0, *) {
            return distance(to: other)
        } else {
            return other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
        }
    }

    /** A date generator function that can be overridden in tests */
    static var nowFunc: (() -> Date)?
    static var now: Date {
        return Date.nowFunc?() ?? Date()
    }

    /** Adapted from: https://gist.github.com/andatta/3b2010604aa4bd553bf0098470f6dbb8 */
    var age: (years: Int, months: Int, days: Int) {
        var years = 0
        var months = 0
        var days = 0

        let cal = Calendar.current
        let now = Date.now
        years = cal.component(.year, from: now) -  cal.component(.year, from: self)

        let currMonth = cal.component(.month, from: now)
        let birthMonth = cal.component(.month, from: self)

        // get difference between current month and birthMonth
        months = currMonth - birthMonth
        // if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0 {
            years = years - 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: now) < cal.component(.day, from: self) {
                months = months - 1
            }
        } else if months == 0 && cal.component(.day, from: now) < cal.component(.day, from: self) {
            years = years - 1
            months = 11
        }

        // calculate the days
        if cal.component(.day, from: now) > cal.component(.day, from: self) {
            days = cal.component(.day, from: now) - cal.component(.day, from: self)
        } else if cal.component(.day, from: now) < cal.component(.day, from: self) {
            let today = cal.component(.day, from: now)
            let date = cal.date(byAdding: .month, value: -1, to: now)
            days = date!.daysInMonth - cal.component(.day, from: self) + today
        } else {
            days = 0
            if months == 12 {
                years = years + 1
                months = 0
            }
        }
        return (years, months, days)
    }

    var daysInMonth: Int {
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }
}
