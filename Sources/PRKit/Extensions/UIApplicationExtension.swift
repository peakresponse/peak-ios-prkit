//
//  UIApplicationExtension.swift
//  PRKit
//
//  Created by Francis Li on 11/4/21.
//

import UIKit

public extension UIApplication {
    static func interfaceOrientation() -> UIInterfaceOrientation {
        var orientation: UIInterfaceOrientation
        if #available(iOS 16.0, *) {
            orientation = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }?
                .effectiveGeometry
                .interfaceOrientation ?? .unknown
        } else if #available(iOS 13.0, *) {
            orientation = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }?
                .interfaceOrientation ?? .unknown
        } else {
            orientation = UIApplication.shared.statusBarOrientation
        }
        return orientation
    }
}
