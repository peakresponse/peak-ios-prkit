//
//  KeyboardsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

enum PickerTestEnum: String, PickerKeyboardSourceEnum {
    case option1, option2, option3

    var description: String {
        switch self {
        case .option1:
            return "Option 1"
        case .option2:
            return "Option 2"
        case .option3:
            return "Option 3"
        }
    }
}

class KeyboardsViewController: UIViewController, FormFieldDelegate {
    @IBOutlet weak var dateTimeField: TextField!
    @IBOutlet weak var pickerField: TextField!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var dateField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputAccessoryView = FormInputAccessoryView(rootView: view)
        dateTimeField.inputAccessoryView = inputAccessoryView
        pickerField.inputAccessoryView = inputAccessoryView
        emailField.inputAccessoryView = inputAccessoryView
        dateField.inputAccessoryView = inputAccessoryView

        pickerField.attributeType = .picker(PickerKeyboardSourceWrapper<PickerTestEnum>())
        pickerField.attributeValue = "option2" as AnyObject

        emailField.keyboardType = .emailAddress

        dateField.attributeValue = "2021-10-31" as AnyObject
    }
}
