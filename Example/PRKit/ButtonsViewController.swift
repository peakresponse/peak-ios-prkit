//
//  ButtonsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 4/22/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import PRKit
import UIKit

class ButtonsViewController: UIViewController {
    @IBAction func buttonPressed() {
        let modal = ModalViewController()
        modal.messageText = "Are you sure you wish to make this incident a red alert?"
        modal.addAction(UIAlertAction(title: "Start Mass Casualty", style: .destructive, handler: { (_) in
            print("destructive")
        }))
        modal.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(modal, animated: true)
    }
}
