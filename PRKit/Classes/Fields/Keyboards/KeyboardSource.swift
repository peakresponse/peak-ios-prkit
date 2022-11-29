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
    func firstIndex(of value: NSObject) -> Int?
    func search(_ query: String?, callback: ((Bool) -> Void)?)
    func title(for value: NSObject?) -> String?
    func title(at index: Int) -> String?
    func value(at index: Int) -> NSObject?
}
