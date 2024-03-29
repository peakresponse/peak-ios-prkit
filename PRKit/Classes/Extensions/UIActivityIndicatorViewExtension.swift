//
//  UIActivityIndicatorView+Extension.swift
//  PRKit
//
//  Created by Francis Li on 12/14/20.
//

import UIKit

public extension UIActivityIndicatorView {
    static func withMediumStyle() -> UIActivityIndicatorView {
        var style: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            style = .medium
        } else {
            style = .white
        }
        return UIActivityIndicatorView(style: style)
    }

    static func withLargeStyle() -> UIActivityIndicatorView {
        var style: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            style = .large
        } else {
            style = .whiteLarge
        }
        return UIActivityIndicatorView(style: style)
    }
}
