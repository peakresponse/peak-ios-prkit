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
}
