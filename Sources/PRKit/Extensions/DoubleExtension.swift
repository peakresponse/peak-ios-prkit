//
//  DoubleExtension.swift
//  PRKit
//
//  Created by Francis Li on 9/5/26.
//

import Foundation

public extension Double {
    public func asTimeString() -> String {
        if self > 3600 {
            return String(format: "%02.0f:%02.0f:%02.0f",
                          self / 3600, self / 60, self.truncatingRemainder(dividingBy: 60))
        }
        return String(format: "%02.0f:%02.0f",
                      self / 60, self.truncatingRemainder(dividingBy: 60))
    }
}
