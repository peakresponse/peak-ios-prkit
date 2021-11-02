//
//  String+Extension.swift
//  PRKit
//
//  Created by Francis Li on 8/13/20.
//

import Foundation

extension String {
    public var localized: String {
        return NSLocalizedString(self, bundle: Bundle(for: type(of: UIApplication.shared.delegate!)), comment: "")
    }
}
