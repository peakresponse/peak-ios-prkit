//
//  UIScreenExtension.swift
//  Pods
//
//  Created by Francis Li on 8/29/25.
//

import UIKit

// From: https://stackoverflow.com/a/76728094
extension UIScreen {
    static public var current: UIScreen? {
        UIWindow.current?.screen
    }
}
