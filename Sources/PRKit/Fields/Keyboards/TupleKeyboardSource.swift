//
//  TupleKeyboardSource.swift
//  PRKit
//
//  Created by Francis Li on 5/15/26.
//

import Foundation

open class TupleKeyboardSource: KeyboardSource {
    public let name: String
    public let items: [(label: String, value: String)]
    public var filtered: [(label: String, value: String)]?

    public init(name: String, items: [(label: String, value: String)]) {
        self.name = name
        self.items = items
    }

    public func count() -> Int {
        if let filtered = filtered {
            return filtered.count
        }
        return items.count
    }

    public func search(_ query: String?, callback: ((Bool) -> Void)?) {
        if let query = query?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty {
            filtered = items.filter({ $0.0.localizedLowercase.contains(query.localizedLowercase) })
        } else {
            filtered = nil
        }
        callback?(false)
    }

    public func title(for value: NSObject?) -> String? {
        return items.first(where: { $0.1 == (value as? String) })?.0
    }

    public func title(at index: Int) -> String? {
        if let filtered = filtered {
            return filtered[index].0
        }
        return items[index].0
    }

    public func value(at index: Int) -> NSObject? {
        if let filtered = filtered {
            return filtered[index].1 as NSObject
        }
        return items[index].1 as NSObject
    }
}
