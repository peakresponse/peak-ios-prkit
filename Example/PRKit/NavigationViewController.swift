//
//  NavigationViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/1/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

class SecondNavigationViewController: UIViewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tabBarItem.image = UIImage(named: "Patient", in: PRKitBundle.instance, compatibleWith: nil)
    }
}

class NavigationViewController: ViewController {
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var button: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tabBarItem.image = UIImage(named: "Dashboard", in: PRKitBundle.instance, compatibleWith: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addSegment(title: "Segment 1")
        segmentedControl.addSegment(title: "Segment 2")
        segmentedControl.addSegment(title: "Segment 3")
    }

    @IBAction func segmentedControlValueChanged(_ sender: SegmentedControl) {
        print(sender.selectedIndex)
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        segmentedControl.selectedIndex = (segmentedControl.selectedIndex + 1) % 3
    }
}
