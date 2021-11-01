//
//  NavigationViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/1/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

class NavigationViewController: UIViewController {
    @IBOutlet weak var segmentedControl: SegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addSegment(title: "Segment 1")
        segmentedControl.addSegment(title: "Segment 2")
        segmentedControl.addSegment(title: "Segment 3")
    }

    @IBAction func segmentedControlValueChanged(_ sender: SegmentedControl) {
        print(sender.selectedIndex)
    }
}
