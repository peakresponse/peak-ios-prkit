//
//  InputsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/3/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PRKit
import UIKit

class InputsViewController: UIViewController, FormFieldDelegate, KeyboardAwareScrollViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }

    // MARK: - FormFieldDelegate

    func formFieldDidChange(_ field: FormField) {
        print(field.text ?? "")
    }
}
