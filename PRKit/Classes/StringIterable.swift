//
//  StringIterable.swift
//  PRKit
//
//  Created by Francis Li on 11/18/21.
//

import Foundation

public protocol StringIterable: CaseIterable, CustomStringConvertible {
    var rawValue: String { get }
}
