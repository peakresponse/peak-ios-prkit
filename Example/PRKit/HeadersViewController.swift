//
//  HeadersViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 10/26/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

class HeadersViewController: UIViewController {
    @IBOutlet weak var commandFooter: CommandFooter!

    @IBAction func primaryPressed() {
        commandFooter.isLoading = true
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] (_) in
            guard let self = self else { return }
            self.commandFooter.isLoading = false
        }
    }
}
