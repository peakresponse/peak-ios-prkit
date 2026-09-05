//
//  String+Extension.swift
//  PRKit
//
//  Created by Francis Li on 8/13/20.
//

import Foundation
import UIKit

public extension String {
    var localized: String {
        var bundle: Bundle
        if let delegate = UIApplication.shared.delegate {
            bundle = Bundle(for: type(of: delegate))
        } else {
            bundle = Bundle.main
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func asDate() -> Date? {
        return ISO8601DateFormatter.date(from: self)
    }

    func asTimeInterval() -> TimeInterval? {
        return TimeInterval(self)
    }
}
