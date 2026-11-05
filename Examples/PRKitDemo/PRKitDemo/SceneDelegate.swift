//
//  SceneDelegate.swift
//  PRKitDemo
//
//  Created by Francis Li on 9/26/26.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let vc = UISplitViewController(style: .doubleColumn)
        vc.setViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu"), for: .primary)
        vc.setViewController(ResponsiveViewController(), for: .secondary)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
