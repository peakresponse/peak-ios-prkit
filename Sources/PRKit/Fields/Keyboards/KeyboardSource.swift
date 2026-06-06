//
//  KeyboardSource.swift
//  PRKit
//
//  Created by Francis Li on 11/30/21.
//

import UIKit

public protocol KeyboardSource: AnyObject {
    var name: String { get }
    var isSectioned: Bool { get }
    func setSectionId(_ id: String?)
    func count() -> Int
    func search(_ query: String?, callback: ((Bool) -> Void)?)
    func title(for value: NSObject?) -> String?
    func title(at index: Int) -> String?
    func value(at index: Int) -> NSObject?
    func clone() -> Self?
}

extension KeyboardSource {
    public var isSectioned: Bool { false }
    public func setSectionId(_ id: String?) { }
    public func clone() -> Self? { nil }
}
