//
//  CustomTabBarViewController.swift
//  PRKit
//
//  Created by Francis Li on 5/11/22.
//

import UIKit

// TODO: handle constant sizes 105 (no action button), 147 (with action button)

open class CustomTabBarController: UIViewController, CustomTabBarDelegate {
    open weak var containerView: UIView!
    open weak var customTabBar: CustomTabBar!
    open var viewControllers: [UIViewController]? {
        didSet {
            updateTabBarItems()
        }
    }
    open var selectedIndex: Int = NSNotFound {
        didSet {
            showSelectedViewController()
        }
    }
    open var selectedViewController: UIViewController? {
        get {
            if let viewControllers, selectedIndex >= 0 && selectedIndex < viewControllers.count {
                return viewControllers[selectedIndex]
            }
            return nil
        }
        set {
            if let newValue, let index = viewControllers?.firstIndex(of: newValue) {
                selectedIndex = index
            } else {
                selectedIndex = NSNotFound
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        self.containerView = containerView

        // set up custom tab bar, overlaying existing tab bar
        let customTabBar = CustomTabBar()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.delegate = self
        customTabBar.isActionButtonEnabled = false
        view.addSubview(customTabBar)
        NSLayoutConstraint.activate([
            customTabBar.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            customTabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -105),
            customTabBar.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            customTabBar.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor)
        ])
        self.customTabBar = customTabBar

        updateTabBarItems()
    }

    open func updateTabBarItems() {
        customTabBar?.items = viewControllers?.map({ $0.tabBarItem })
        customTabBar?.selectedItem = customTabBar?.items?.first
        selectedViewController = viewControllers?.first
    }

    open func showSelectedViewController() {
        for vc in children {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            vc.didMove(toParent: nil)
        }
        if let containerView, let vc = selectedViewController {
            vc.willMove(toParent: self)
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.view.frame = containerView.bounds
            vc.didMove(toParent: self)
        }
    }

    // MARK: - TabBarDelegate

    open func customTabBar(_ tabBar: CustomTabBar, didSelect index: Int) {
        selectedIndex = index
    }

    open func customTabBar(_ tabBar: CustomTabBar, didPress button: UIButton) {

    }
}
