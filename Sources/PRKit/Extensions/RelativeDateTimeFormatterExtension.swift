//
//  RelativeDateTimeFormatterExtension.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import Foundation

@available(iOS 13.0, *)
public extension RelativeDateTimeFormatter {
    static let defaultFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    static func localizedString(for date: Date, relativeTo: Date = Date()) -> String {
        return defaultFormatter.localizedString(for: date, relativeTo: relativeTo)
    }
}
