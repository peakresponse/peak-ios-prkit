//
//  KeyboardsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Keyboardy
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

class KeyboardsViewController: BaseViewController, FormFieldDelegate {
    weak var formGridView: FormGridView!
    weak var containerView: UIView!
    weak var dateTimeField: TextField!
    weak var pickerField: TextField!
    weak var emailField: TextField!
    weak var dateField: TextField!
    weak var integerField: TextField!
    weak var decimalField: TextField!
    weak var ageField: TextField!
    weak var multiField: TextField!
    weak var singleField: TextField!
    weak var multiSearchField: TextField!
    weak var singleSearchField: TextField!
    weak var comboField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        let formGridView = FormGridView()
        formGridView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formGridView)
        NSLayoutConstraint.activate([
            formGridView.frameLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            formGridView.frameLayoutGuide.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            formGridView.frameLayoutGuide.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            formGridView.frameLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            formGridView.contentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            formGridView.contentView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        self.formGridView = formGridView

        let inputAccessoryView = FormInputAccessoryView(rootView: view)
        var tag = 1

        let dateField = PRKit.TextField()
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.labelText = "Date"
        dateField.attributeType = .date
        dateField.attributeValue = "2021-10-31" as NSObject
        dateField.inputAccessoryView = inputAccessoryView
        dateField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(dateField)
        self.dateField = dateField

        let dateTimeField = PRKit.TextField()
        dateTimeField.translatesAutoresizingMaskIntoConstraints = false
        dateTimeField.labelText = "Date/Time"
        dateTimeField.attributeType = .datetime
        dateTimeField.attributeValue = "2021-10-31" as NSObject
        dateTimeField.inputAccessoryView = inputAccessoryView
        dateTimeField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(dateTimeField)
        self.dateTimeField = dateTimeField

        let emailField = PRKit.TextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.labelText = "Email"
        emailField.attributeType = .text
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = inputAccessoryView
        emailField.tag = tag
        tag += 1
        emailField.formGridSpan = 2
        formGridView.addArrangedSubview(emailField)
        self.emailField = emailField

        let pickerField = PRKit.TextField()
        pickerField.translatesAutoresizingMaskIntoConstraints = false
        pickerField.labelText = "Picker"
        pickerField.attributeType = .picker(EnumKeyboardSource<PickerTestEnum>())
        pickerField.attributeValue = "option2" as NSObject
        pickerField.inputAccessoryView = inputAccessoryView
        pickerField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(pickerField)
        self.pickerField = pickerField

        let integerField = PRKit.TextField()
        integerField.translatesAutoresizingMaskIntoConstraints = false
        integerField.labelText = "Integer"
        integerField.attributeType = .integer
        integerField.unitText = " bpm"
        integerField.inputAccessoryView = inputAccessoryView
        integerField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(integerField)
        self.integerField = integerField

        let decimalField = PRKit.TextField()
        decimalField.translatesAutoresizingMaskIntoConstraints = false
        decimalField.labelText = "Decimal"
        decimalField.attributeType = .decimal
        decimalField.inputAccessoryView = inputAccessoryView
        decimalField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(decimalField)
        self.decimalField = decimalField

        let ageField = PRKit.TextField()
        ageField.translatesAutoresizingMaskIntoConstraints = false
        ageField.labelText = "Integer w/ Unit"
        ageField.attributeType = .integerWithUnit(EnumKeyboardSource<AgeTestUnits>())
        ageField.attributeValue = ["23", "years"] as NSObject
        ageField.inputAccessoryView = inputAccessoryView
        ageField.tag = tag
        tag += 1
        ageField.formGridSpan = 2
        formGridView.addArrangedSubview(ageField)
        self.ageField = ageField

        let multiField = PRKit.TextField()
        multiField.translatesAutoresizingMaskIntoConstraints = false
        multiField.labelText = "Multi select"
        multiField.attributeType = .multi(EnumKeyboardSource<PickerTestEnum>())
        multiField.inputAccessoryView = inputAccessoryView
        multiField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(multiField)
        self.multiField = multiField

        let singleField = PRKit.TextField()
        singleField.translatesAutoresizingMaskIntoConstraints = false
        singleField.labelText = "Single select"
        singleField.attributeType = .single(EnumKeyboardSource<PickerTestEnum>())
        singleField.inputAccessoryView = inputAccessoryView
        singleField.tag = tag
        tag += 1
        singleField.formGridOffset = 1
        formGridView.addArrangedSubview(singleField)
        self.singleField = singleField

        let multiSearchField = PRKit.TextField()
        multiSearchField.translatesAutoresizingMaskIntoConstraints = false
        multiSearchField.labelText = "Multi search"
        multiSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(),
                                                                isMultiSelect: true))
        multiSearchField.inputAccessoryView = inputAccessoryView
        multiSearchField.tag = tag
        tag += 1
        multiSearchField.formGridOffset = 1
        formGridView.addArrangedSubview(multiSearchField)
        self.multiSearchField = multiSearchField

        let singleSearchField = PRKit.TextField()
        singleSearchField.translatesAutoresizingMaskIntoConstraints = false
        singleSearchField.labelText = "Single search"
        singleSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(),
                                                                 isMultiSelect: false))
        singleSearchField.inputAccessoryView = inputAccessoryView
        singleSearchField.tag = tag
        tag += 1
        formGridView.addArrangedSubview(singleSearchField)
        self.singleSearchField = singleSearchField

        let searchKeyboard = SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: false)
        let pickerKeyboard = PickerKeyboard()
        pickerKeyboard.source = EnumKeyboardSource<PickerTestEnum>()
        let comboField = PRKit.TextField()
        comboField.translatesAutoresizingMaskIntoConstraints = false
        comboField.labelText = "Combo"
        comboField.attributeType = .custom(ComboKeyboard(keyboards: [
            searchKeyboard,
            pickerKeyboard
        ], titles: [
            "Search",
            "Picker"
        ]))
        comboField.inputAccessoryView = inputAccessoryView
        comboField.tag = tag
        tag += 1
        comboField.formGridOffset = 1
        formGridView.addArrangedSubview(comboField)
        self.comboField = comboField

        formGridView.updateLayout()
    }

    override func keyboardDidShow(_ notification: Notification) {
        super.keyboardDidShow(notification)
        if let firstResponder = formGridView.firstResponder {
            var rect = firstResponder.convert(firstResponder.bounds, to: formGridView)
            rect.origin.y += 16
            formGridView.scrollRectToVisible(rect, animated: true)
        }
    }

    // MARK: - FormFieldDelegate

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
}
