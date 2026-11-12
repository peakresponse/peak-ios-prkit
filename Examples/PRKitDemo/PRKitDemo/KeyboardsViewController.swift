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
    weak var scrollView: UIScrollView!
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

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.frameLayoutGuide.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            scrollView.frameLayoutGuide.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.scrollView = scrollView

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollView.contentLayoutGuide.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        self.containerView = containerView

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
        containerView.addSubview(dateField)
        NSLayoutConstraint.activate([
            dateField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            dateField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            dateField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.dateField = dateField

        let dateTimeField = PRKit.TextField()
        dateTimeField.translatesAutoresizingMaskIntoConstraints = false
        dateTimeField.labelText = "Date/Time"
        dateTimeField.attributeType = .datetime
        dateTimeField.attributeValue = "2021-10-31" as NSObject
        dateTimeField.inputAccessoryView = inputAccessoryView
        dateTimeField.tag = tag
        tag += 1
        containerView.addSubview(dateTimeField)
        NSLayoutConstraint.activate([
            dateTimeField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 16),
            dateTimeField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            dateTimeField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.dateTimeField = dateTimeField

        let emailField = PRKit.TextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.labelText = "Email"
        emailField.attributeType = .text
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = inputAccessoryView
        emailField.tag = tag
        tag += 1
        containerView.addSubview(emailField)
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: dateTimeField.bottomAnchor, constant: 16),
            emailField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            emailField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.emailField = emailField

        let pickerField = PRKit.TextField()
        pickerField.translatesAutoresizingMaskIntoConstraints = false
        pickerField.labelText = "Picker"
        pickerField.attributeType = .picker(EnumKeyboardSource<PickerTestEnum>())
        pickerField.attributeValue = "option2" as NSObject
        pickerField.inputAccessoryView = inputAccessoryView
        pickerField.tag = tag
        tag += 1
        containerView.addSubview(pickerField)
        NSLayoutConstraint.activate([
            pickerField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            pickerField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            pickerField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.pickerField = pickerField

        let integerField = PRKit.TextField()
        integerField.translatesAutoresizingMaskIntoConstraints = false
        integerField.labelText = "Integer"
        integerField.attributeType = .integer
        integerField.unitText = " bpm"
        integerField.inputAccessoryView = inputAccessoryView
        integerField.tag = tag
        tag += 1
        containerView.addSubview(integerField)
        NSLayoutConstraint.activate([
            integerField.topAnchor.constraint(equalTo: pickerField.bottomAnchor, constant: 16),
            integerField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            integerField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.integerField = integerField

        let decimalField = PRKit.TextField()
        decimalField.translatesAutoresizingMaskIntoConstraints = false
        decimalField.labelText = "Decimal"
        decimalField.attributeType = .decimal
        decimalField.inputAccessoryView = inputAccessoryView
        decimalField.tag = tag
        tag += 1
        containerView.addSubview(decimalField)
        NSLayoutConstraint.activate([
            decimalField.topAnchor.constraint(equalTo: integerField.bottomAnchor, constant: 16),
            decimalField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            decimalField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.decimalField = decimalField

        let ageField = PRKit.TextField()
        ageField.translatesAutoresizingMaskIntoConstraints = false
        ageField.labelText = "Integer w/ Unit"
        ageField.attributeType = .integerWithUnit(EnumKeyboardSource<AgeTestUnits>())
        ageField.attributeValue = ["23", "years"] as NSObject
        ageField.inputAccessoryView = inputAccessoryView
        ageField.tag = tag
        tag += 1
        containerView.addSubview(ageField)
        NSLayoutConstraint.activate([
            ageField.topAnchor.constraint(equalTo: decimalField.bottomAnchor, constant: 16),
            ageField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            ageField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.ageField = ageField

        let multiField = PRKit.TextField()
        multiField.translatesAutoresizingMaskIntoConstraints = false
        multiField.labelText = "Multi select"
        multiField.attributeType = .multi(EnumKeyboardSource<PickerTestEnum>())
        multiField.inputAccessoryView = inputAccessoryView
        multiField.tag = tag
        tag += 1
        containerView.addSubview(multiField)
        NSLayoutConstraint.activate([
            multiField.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 16),
            multiField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            multiField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.multiField = multiField

        let singleField = PRKit.TextField()
        singleField.translatesAutoresizingMaskIntoConstraints = false
        singleField.labelText = "Single select"
        singleField.attributeType = .single(EnumKeyboardSource<PickerTestEnum>())
        singleField.inputAccessoryView = inputAccessoryView
        singleField.tag = tag
        tag += 1
        containerView.addSubview(singleField)
        NSLayoutConstraint.activate([
            singleField.topAnchor.constraint(equalTo: multiField.bottomAnchor, constant: 16),
            singleField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            singleField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.singleField = singleField

        let multiSearchField = PRKit.TextField()
        multiSearchField.translatesAutoresizingMaskIntoConstraints = false
        multiSearchField.labelText = "Multi search"
        multiSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(),
                                                                isMultiSelect: true))
        multiSearchField.inputAccessoryView = inputAccessoryView
        multiSearchField.tag = tag
        tag += 1
        containerView.addSubview(multiSearchField)
        NSLayoutConstraint.activate([
            multiSearchField.topAnchor.constraint(equalTo: singleField.bottomAnchor, constant: 16),
            multiSearchField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            multiSearchField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        self.multiSearchField = multiSearchField

        let singleSearchField = PRKit.TextField()
        singleSearchField.translatesAutoresizingMaskIntoConstraints = false
        singleSearchField.labelText = "Single search"
        singleSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(),
                                                                 isMultiSelect: false))
        singleSearchField.inputAccessoryView = inputAccessoryView
        singleSearchField.tag = tag
        tag += 1
        containerView.addSubview(singleSearchField)
        NSLayoutConstraint.activate([
            singleSearchField.topAnchor.constraint(equalTo: multiSearchField.bottomAnchor, constant: 16),
            singleSearchField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            singleSearchField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
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
        containerView.addSubview(comboField)
        NSLayoutConstraint.activate([
            comboField.topAnchor.constraint(equalTo: singleSearchField.bottomAnchor, constant: 16),
            comboField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            comboField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: comboField.bottomAnchor, constant: 16)
        ])
        self.comboField = comboField
    }

    override func keyboardDidShow(_ notification: Notification) {
        super.keyboardDidShow(notification)
        if let firstResponder = scrollView.firstResponder {
            var rect = firstResponder.convert(firstResponder.bounds, to: scrollView)
            rect.origin.y += 16
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    // MARK: - FormFieldDelegate

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
}
