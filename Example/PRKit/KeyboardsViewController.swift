//
//  KeyboardsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

enum PickerTestEnum: String, PickerKeyboardSourceEnum, StringIterable {
    case option1, option2, option3, option4, option5, option6

    var description: String {
        switch self {
        case .option1:
            return "Option 1"
        case .option2:
            return "Option 2"
        case .option3:
            return "Option 3"
        case .option4:
            return "Option 4"
        case .option5:
            return "Option 5"
        case .option6:
            return "Option 6"
        }
    }
}

enum AgeTestUnits: String, PickerKeyboardSourceEnum {
    case years, months, days
    var description: String {
        return rawValue
    }
}

class KeyboardsViewController: UIViewController, FormFieldDelegate, KeyboardAwareScrollViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTimeField: TextField!
    @IBOutlet weak var pickerField: TextField!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var dateField: TextField!
    @IBOutlet weak var integerField: TextField!
    @IBOutlet weak var decimalField: TextField!
    @IBOutlet weak var ageField: TextField!
    @IBOutlet weak var multiField: TextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputAccessoryView = FormInputAccessoryView(rootView: view)
        dateTimeField.inputAccessoryView = inputAccessoryView
        pickerField.inputAccessoryView = inputAccessoryView
        emailField.inputAccessoryView = inputAccessoryView
        dateField.inputAccessoryView = inputAccessoryView
        integerField.inputAccessoryView = inputAccessoryView
        decimalField.inputAccessoryView = inputAccessoryView
        ageField.inputAccessoryView = inputAccessoryView
        multiField.inputAccessoryView = inputAccessoryView

        pickerField.attributeType = .picker(PickerKeyboardSourceWrapper<PickerTestEnum>())
        pickerField.attributeValue = "option2" as AnyObject

        emailField.keyboardType = .emailAddress

        dateField.attributeValue = "2021-10-31" as AnyObject

        integerField.unitLabel.text = " bpm"

        ageField.attributeType = .integerWithUnit(PickerKeyboardSourceWrapper<AgeTestUnits>())

        multiField.attributeType = .multi(MultiSelectKeyboardSourceWrapper<PickerTestEnum>())
    }
}
