//
//  AppViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 5/27/26.
//

import Foundation
import UIKit

class AppViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            UINavigationController(rootViewController: RootViewController()),
        ]
    }
}
