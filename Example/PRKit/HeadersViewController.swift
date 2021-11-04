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
    @IBOutlet weak var commandHeader: CommandHeader!
    @IBOutlet weak var itemCommandHeader: CommandHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        commandHeader.userLabelText = "Testing"

        itemCommandHeader.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        itemCommandHeader.rightBarButtonItem = UIBarButtonItem(title: "Save & Exit", style: .done, target: nil, action: nil)
    }

    @IBAction func primaryPressed() {
        commandFooter.isLoading = true
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] (_) in
            guard let self = self else { return }
            self.commandFooter.isLoading = false
        }
    }
}
