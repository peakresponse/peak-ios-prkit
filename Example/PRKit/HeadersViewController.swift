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
    @IBOutlet weak var backCommandHeader: CommandHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        commandHeader.userLabelText = "Testing"

        itemCommandHeader.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        itemCommandHeader.rightBarButtonItem = UIBarButtonItem(title: "Save & Exit", style: .done, target: nil, action: nil)

        let backItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        backItem.image = UIImage(named: "ChevronLeft40px", in: PRKitBundle.instance, compatibleWith: nil)
        backCommandHeader.leftBarButtonItem = backItem

        backCommandHeader.centerBarButtonItem = UIBarButtonItem(title: "Center", style: .plain, target: nil, action: nil)

        let spinner = UIActivityIndicatorView.withMediumStyle()
        spinner.color = .base500
        spinner.startAnimating()
        let spinnerItem = UIBarButtonItem(customView: spinner)
        backCommandHeader.rightBarButtonItem = spinnerItem
    }

    @IBAction func primaryPressed() {
        commandFooter.isLoading = true
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] (_) in
            guard let self = self else { return }
            self.commandFooter.isLoading = false
        }
    }
}
