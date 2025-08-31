//
//  UIWindowExtension.swift
//  Pods
//
//  Created by Francis Li on 8/29/25.
//

// From: https://stackoverflow.com/a/76728094
extension UIWindow {
    static public var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}
