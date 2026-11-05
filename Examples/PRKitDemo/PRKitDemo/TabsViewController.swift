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
            if $0.title == "Triage" {
                let segmentedControl = SegmentedControl()
                segmentedControl.translatesAutoresizingMaskIntoConstraints = false
                segmentedControl.addSegment(title: "Segment 1")
                segmentedControl.addSegment(title: "Segment 2")
                segmentedControl.addSegment(title: "Segment 3")
                segmentedControl.addAction(UIAction(title: "segmentedControlValueChanged") { _ in
                    print("segmentedControl.selectedIndex=", segmentedControl.selectedIndex)
                }, for: .valueChanged)
                view.addSubview(segmentedControl)
                NSLayoutConstraint.activate([
                    segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                    segmentedControl.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
                    segmentedControl.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
                ])

                let button = PRKit.Button()
                button.style = .primary
                button.size = .small
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle("Next", for: .normal)
                button.addAction(UIAction(title: "buttonPressed") { _ in
                    segmentedControl.selectedIndex = (segmentedControl.selectedIndex + 1) % 3
                }, for: .touchUpInside)
                view.addSubview(button)
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
                    button.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor)
                ])
            }
            return vc
        }
        super.viewDidLoad()
    }
}
