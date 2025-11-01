//
//  InputsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/3/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PRKit
import UIKit

class InputsViewController: ViewController, FormFieldDelegate, KeyboardAwareScrollViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var emptyField: TextField!
    @IBOutlet weak var disabledField: TextField!
    @IBOutlet weak var passwordField: PasswordField!
    @IBOutlet weak var errorField: TextField!
    @IBOutlet weak var statusField: TextField!
    @IBOutlet weak var radioGroup: FormRadioGroup!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputAccessoryView = FormInputAccessoryView(rootView: view)
        emptyField.inputAccessoryView = inputAccessoryView
        emptyField.inputAccessoryViewOtherButtonTitle = "Open Tag"
        emptyField.accessoryButtonImage = UIImage(named: "Phone40px", in: PRKitBundle.instance, compatibleWith: nil)
        disabledField.inputAccessoryView = inputAccessoryView
        passwordField.inputAccessoryView = inputAccessoryView
        errorField.inputAccessoryView = inputAccessoryView

        radioGroup.inputAccessoryView = inputAccessoryView
        radioGroup.isDeselectable = true
        radioGroup.labelText = "Radio Group"
        radioGroup.addRadioButton(labelText: "Arrived", value: "arrived" as NSObject)
        radioGroup.addRadioButton(labelText: "En Route", value: "enroute" as NSObject)
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

    func formComponentDidChange(_ component: FormComponent) {
        if let field = component as? FormField {
            print(field.text ?? "")
        } else {
            print(component.attributeValue ?? "nil")
        }
    }

    func formFieldDidPressOther(_ field: FormField) {
        print("other pressed")
    }

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true)
    }
}
