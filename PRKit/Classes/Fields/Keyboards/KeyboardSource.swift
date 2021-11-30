//
//  KeyboardSource.swift
//  PRKit
//
//  Created by Francis Li on 11/30/21.
//

import UIKit

public protocol KeyboardSource: AnyObject {
    func firstIndex(of value: String) -> Int?
    func title(for value: String?) -> String?
    func title(at index: Int) -> String?
    func value(at index: Int) -> String?
    func count() -> Int
}

open class EnumKeyboardSource<T: StringCaseIterable>: NSObject, KeyboardSource {
    public func firstIndex(of value: String) -> Int? {
        return T.allCases.map { $0.rawValue }.firstIndex(of: value)
    }

    public func title(for value: String?) -> String? {
        if let value = value {
            return T.allCases.first(where: {$0.rawValue == value})?.description
        }
        return nil
    }

    public func title(at index: Int) -> String? {
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: index)].description
    }

    public func value(at index: Int) -> String? {
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: index)].rawValue
    }

    public func count() -> Int {
        return T.allCases.count
    }
}
