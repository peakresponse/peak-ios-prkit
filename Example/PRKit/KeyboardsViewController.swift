//
//  KeyboardsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

enum PickerTestEnum: String, StringCaseIterable {
    case option1, option2, option3, option4, option5, option6, option7, option8

    var description: String {
        switch self {
        case .option1:
            return "Option 1"
        case .option2:
            return "Option 2"
        case .option3:
            return "Option 3"
        case .option4:
            return "Option 4 with Long Description to Test Wrapping"
        case .option5:
            return "Option 5"
        case .option6:
            return "Option 6 with Long Description to Test Wrapping"
        case .option7:
            return "Option 7 with Long Description to Test Wrapping"
        case .option8:
            return "Option 8"
        }
    }
}

enum AgeTestUnits: String, StringCaseIterable {
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
    @IBOutlet weak var singleField: TextField!
    @IBOutlet weak var multiSearchField: TextField!
    @IBOutlet weak var singleSearchField: TextField!
    @IBOutlet weak var comboField: TextField!

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
        singleField.inputAccessoryView = inputAccessoryView
        multiSearchField.inputAccessoryView = inputAccessoryView
        singleSearchField.inputAccessoryView = inputAccessoryView
        comboField.inputAccessoryView = inputAccessoryView

        pickerField.attributeType = .picker(EnumKeyboardSource<PickerTestEnum>())
        pickerField.attributeValue = "option2" as NSObject

        emailField.keyboardType = .emailAddress

        dateField.attributeValue = "2021-10-31" as NSObject

        integerField.unitText = " bpm"

        ageField.attributeType = .integerWithUnit(EnumKeyboardSource<AgeTestUnits>())
        ageField.attributeValue = ["23", "years"] as NSObject

        multiField.attributeType = .multi(EnumKeyboardSource<PickerTestEnum>())
        singleField.attributeType = .single(EnumKeyboardSource<PickerTestEnum>())

        multiSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: true))

        singleSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: false))

        let searchKeyboard = SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: false)
        let pickerKeyboard = PickerKeyboard()
        pickerKeyboard.source = EnumKeyboardSource<PickerTestEnum>()
        comboField.attributeType = .custom(ComboKeyboard(keyboards: [
            searchKeyboard,
            pickerKeyboard
        ], titles: [
            "Search",
            "Picker"
        ]))
    }

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
}
