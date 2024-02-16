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

    @IBOutlet weak var emptyField: TextField!
    @IBOutlet weak var disabledField: TextField!
    @IBOutlet weak var passwordField: PasswordField!
    @IBOutlet weak var errorField: TextField!
    @IBOutlet weak var statusField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputAccessoryView = FormInputAccessoryView(rootView: view)
        emptyField.inputAccessoryView = inputAccessoryView
        emptyField.inputAccessoryViewOtherButtonTitle = "Open Tag"
        disabledField.inputAccessoryView = inputAccessoryView
        passwordField.inputAccessoryView = inputAccessoryView
        errorField.inputAccessoryView = inputAccessoryView
    }

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

    func formFieldDidPressOther(_ field: FormField) {
        print("other pressed")
    }

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true)
    }
}
