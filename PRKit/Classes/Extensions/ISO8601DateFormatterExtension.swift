//
//  ISO8601DateFormatterExtension.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import Foundation

public extension ISO8601DateFormatter {
    static let defaultFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static func date(from string: Any?) -> Date? {
        if let string = string as? String {
            return defaultFormatter.date(from: string)
        }
        return nil
    }

    static func string(from date: Date?) -> String? {
        if let date = date {
            return defaultFormatter.string(from: date)
        }
        return nil
    }
}
