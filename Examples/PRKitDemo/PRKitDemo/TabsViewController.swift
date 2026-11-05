//
//  TabsViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 11/4/26.
//

import PRKit
import UIKit

private let items = [
    UITabBarItem(title: "Triage", image: PRKitBundle.image(named: "Triage"), selectedImage: nil),
    UITabBarItem(title: "Treat", image: PRKitBundle.image(named: "Treat"), selectedImage: nil),
    UITabBarItem(title: "Stage", image: PRKitBundle.image(named: "Stage"), selectedImage: nil),
    UITabBarItem(title: "Transport", image: PRKitBundle.image(named: "Transport"), selectedImage: nil),
    UITabBarItem(title: "Reunify", image: PRKitBundle.image(named: "Reunify"), selectedImage: nil),
]

class TabsViewController: CustomTabBarController {
    override func viewDidLoad() {
        viewControllers = items.map {
            let vc = UIViewController()
            vc.tabBarItem = $0
            let view = vc.view!
            let imageView = UIImageView(image: $0.image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
            return vc
        }
        super.viewDidLoad()
    }
}
