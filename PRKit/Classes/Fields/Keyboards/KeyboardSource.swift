//
//  KeyboardSource.swift
//  PRKit
//
//  Created by Francis Li on 11/30/21.
//

import UIKit

public protocol KeyboardSource: AnyObject {
    var name: String { get }
    func count() -> Int
    func firstIndex(of value: String) -> Int?
    func search(_ query: String?)
    func title(for value: String?) -> String?
    func title(at index: Int) -> String?
    func value(at index: Int) -> String?
}

open class EnumKeyboardSource<T: StringCaseIterable>: NSObject, KeyboardSource {
    open var name: String {
        return String(describing: T.self)
    }
    open var filtered: [T]?

    open func count() -> Int {
        if let filtered = filtered {
            return filtered.count
        }
        return T.allCases.count
    }

    open func firstIndex(of value: String) -> Int? {
        if let filtered = filtered {
            return filtered.map { $0.rawValue }.firstIndex(of: value)
        }
        return T.allCases.map { $0.rawValue }.firstIndex(of: value)
    }

    open func search(_ query: String?) {
        if let query = query, !query.isEmpty {
            filtered = T.allCases.filter { $0.description.localizedLowercase.contains(query.localizedLowercase) }
        } else {
            filtered = nil
        }
    }

    open func title(for value: String?) -> String? {
        if let value = value {
            return T.allCases.first(where: {$0.rawValue == value})?.description
        }
        return nil
    }

    open func title(at index: Int) -> String? {
        if let filtered = filtered {
            return filtered[filtered.index(filtered.startIndex, offsetBy: index)].description
        }
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: index)].description
    }

    open func value(at index: Int) -> String? {
        if let filtered = filtered {
            return filtered[filtered.index(filtered.startIndex, offsetBy: index)].rawValue
        }
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: index)].rawValue
    }
}
