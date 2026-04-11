//
//  EnumKeyboardSource.swift
//  PRKit
//
//  Created by Francis Li on 9/19/22.
//

import Foundation

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

    open func firstIndex(of value: NSObject) -> Int? {
        guard let value = value as? String else { return nil }
        if let filtered = filtered {
            return filtered.map { $0.rawValue }.firstIndex(of: value)
        }
        return T.allCases.map { $0.rawValue }.firstIndex(of: value)
    }

    open func search(_ query: String?, callback: ((Bool) -> Void)? = nil) {
        if let query = query?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty {
            filtered = T.allCases.filter { $0.description.localizedLowercase.contains(query.localizedLowercase) }
        } else {
            filtered = nil
        }
        callback?(false)
    }

    open func title(for value: NSObject?) -> String? {
        if let value = value as? String {
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

    open func value(at index: Int) -> NSObject? {
        if let filtered = filtered {
            return filtered[filtered.index(filtered.startIndex, offsetBy: index)].rawValue as NSObject
        }
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: index)].rawValue as NSObject
    }
}
