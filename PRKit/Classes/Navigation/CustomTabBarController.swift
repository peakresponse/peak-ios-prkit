//
//  CustomTabBarViewController.swift
//  PRKit
//
//  Created by Francis Li on 5/11/22.
//

import UIKit

@IBDesignable
open class CustomTabBarPlaceholder: UITabBar {
    @IBInspectable open var height: CGFloat = 147
    @IBInspectable open var isActionButtonEnabled: Bool = true

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = height
        // adjust for safe area
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let insets = window.safeAreaInsets
            sizeThatFits.height += insets.bottom
        }
        return sizeThatFits
    }
}

open class CustomTabBarController: UITabBarController, CustomTabBarDelegate {
    open weak var customTabBar: CustomTabBar!

    open override func viewDidLoad() {
        super.viewDidLoad()

        // set up custom tab bar, overlaying existing tab bar
        let customTabBar = CustomTabBar(frame: tabBar.frame)
        customTabBar.delegate = self
        customTabBar.isActionButtonEnabled = (tabBar as? CustomTabBarPlaceholder)?.isActionButtonEnabled ?? true
        customTabBar.items = viewControllers?.map({ $0.tabBarItem })
        customTabBar.selectedItem = customTabBar.items?.first
        self.customTabBar = customTabBar
        // hide default tab bar, add to superview on top
        tabBar.alpha = 0
        tabBar.superview?.addSubview(customTabBar)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // always ensure custom tab bar is arranged in front of default tab bar
        customTabBar.frame = tabBar.frame
        tabBar.superview?.bringSubviewToFront(customTabBar)
    }

    // MARK: - TabBarDelegate

    open func customTabBar(_ tabBar: CustomTabBar, didSelect index: Int) {
        selectedIndex = index
    }

    open func customTabBar(_ tabBar: CustomTabBar, didPress button: UIButton) {

    }
}
