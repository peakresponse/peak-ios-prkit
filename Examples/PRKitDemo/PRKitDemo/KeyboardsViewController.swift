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

class KeyboardsViewController: ViewController, FormFieldDelegate, KeyboardAwareScrollViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateField: TextField!
    @IBOutlet weak var dateTimeField: TextField!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var pickerField: TextField!
    @IBOutlet weak var integerField: TextField!
    @IBOutlet weak var decimalField: TextField!
    @IBOutlet weak var ageField: TextField!
    @IBOutlet weak var multiField: TextField!
    @IBOutlet weak var singleField: TextField!
    @IBOutlet weak var multiSearchField: TextField!
    @IBOutlet weak var singleSearchField: TextField!
    @IBOutlet weak var comboField: TextField!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputAccessoryView = FormInputAccessoryView(rootView: view)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewBottomConstraint
        ])
        self.scrollView = scrollView
        self.scrollViewBottomConstraint = scrollViewBottomConstraint

        var tag = 1

        let dateField = TextField()
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.delegate = self
        dateField.labelText = "Date"
        dateField.attributeType = .date
        dateField.attributeValue = "2021-10-31" as NSObject
        dateField.inputAccessoryView = inputAccessoryView
        dateField.tag = tag
        tag += 1
        scrollView.addSubview(dateField)
        NSLayoutConstraint.activate([
            dateField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            dateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.dateField = dateField

        let dateTimeField = TextField()
        dateTimeField.translatesAutoresizingMaskIntoConstraints = false
        dateTimeField.delegate = self
        dateTimeField.labelText = "Date & Time"
        dateTimeField.attributeType = .datetime
        dateTimeField.inputAccessoryView = inputAccessoryView
        dateTimeField.tag = tag
        tag += 1
        scrollView.addSubview(dateTimeField)
        NSLayoutConstraint.activate([
            dateTimeField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 20),
            dateTimeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTimeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.dateTimeField = dateTimeField

        let emailField = TextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.delegate = self
        emailField.labelText = "Email address"
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = inputAccessoryView
        emailField.tag = tag
        tag += 1
        scrollView.addSubview(emailField)
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: dateTimeField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.emailField = emailField

        let pickerField = TextField()
        pickerField.translatesAutoresizingMaskIntoConstraints = false
        pickerField.delegate = self
        pickerField.labelText = "Picker"
        pickerField.attributeType = .picker(EnumKeyboardSource<PickerTestEnum>())
        pickerField.attributeValue = "option2" as NSObject
        pickerField.inputAccessoryView = inputAccessoryView
        pickerField.tag = tag
        tag += 1
        scrollView.addSubview(pickerField)
        NSLayoutConstraint.activate([
            pickerField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            pickerField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.pickerField = pickerField

        let integerField = TextField()
        integerField.translatesAutoresizingMaskIntoConstraints = false
        integerField.delegate = self
        integerField.labelText = "Integer"
        integerField.attributeType = .integer
        integerField.unitText = " bpm"
        integerField.inputAccessoryView = inputAccessoryView
        integerField.tag = tag
        tag += 1
        scrollView.addSubview(integerField)
        NSLayoutConstraint.activate([
            integerField.topAnchor.constraint(equalTo: pickerField.bottomAnchor, constant: 20),
            integerField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            integerField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.integerField = integerField

        let decimalField = TextField()
        decimalField.translatesAutoresizingMaskIntoConstraints = false
        decimalField.delegate = self
        decimalField.labelText = "Decimal"
        decimalField.attributeType = .decimal
        decimalField.inputAccessoryView = inputAccessoryView
        decimalField.tag = tag
        tag += 1
        scrollView.addSubview(decimalField)
        NSLayoutConstraint.activate([
            decimalField.topAnchor.constraint(equalTo: integerField.bottomAnchor, constant: 20),
            decimalField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            decimalField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.decimalField = decimalField

        let ageField = TextField()
        ageField.translatesAutoresizingMaskIntoConstraints = false
        ageField.delegate = self
        ageField.labelText = "Integer w/ Unit"
        ageField.attributeType = .integerWithUnit(EnumKeyboardSource<AgeTestUnits>())
        ageField.attributeValue = ["23", "years"] as NSObject
        ageField.inputAccessoryView = inputAccessoryView
        ageField.tag = tag
        tag += 1
        scrollView.addSubview(ageField)
        NSLayoutConstraint.activate([
            ageField.topAnchor.constraint(equalTo: decimalField.bottomAnchor, constant: 20),
            ageField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.ageField = ageField

        let multiField = TextField()
        multiField.translatesAutoresizingMaskIntoConstraints = false
        multiField.delegate = self
        multiField.labelText = "Multi Select"
        multiField.attributeType = .multi(EnumKeyboardSource<PickerTestEnum>())
        multiField.inputAccessoryView = inputAccessoryView
        multiField.tag = tag
        tag += 1
        scrollView.addSubview(multiField)
        NSLayoutConstraint.activate([
            multiField.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 20),
            multiField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            multiField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.multiField = multiField

        let singleField = TextField()
        singleField.translatesAutoresizingMaskIntoConstraints = false
        singleField.delegate = self
        singleField.labelText = "Single Select"
        singleField.attributeType = .multi(EnumKeyboardSource<PickerTestEnum>())
        singleField.inputAccessoryView = inputAccessoryView
        singleField.tag = tag
        tag += 1
        scrollView.addSubview(singleField)
        NSLayoutConstraint.activate([
            singleField.topAnchor.constraint(equalTo: multiField.bottomAnchor, constant: 20),
            singleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            singleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.singleField = singleField

        let multiSearchField = TextField()
        multiSearchField.translatesAutoresizingMaskIntoConstraints = false
        multiSearchField.delegate = self
        multiSearchField.labelText = "Multi Select w/ Search"
        multiSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: true))
        multiSearchField.inputAccessoryView = inputAccessoryView
        multiSearchField.tag = tag
        tag += 1
        scrollView.addSubview(multiSearchField)
        NSLayoutConstraint.activate([
            multiSearchField.topAnchor.constraint(equalTo: singleField.bottomAnchor, constant: 20),
            multiSearchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            multiSearchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.multiSearchField = multiSearchField

        let singleSearchField = TextField()
        singleSearchField.translatesAutoresizingMaskIntoConstraints = false
        singleSearchField.delegate = self
        singleSearchField.labelText = "Single Select"
        singleSearchField.attributeType = .custom(SearchKeyboard(source: EnumKeyboardSource<PickerTestEnum>(), isMultiSelect: false))
        singleSearchField.inputAccessoryView = inputAccessoryView
        singleSearchField.tag = tag
        tag += 1
        scrollView.addSubview(singleSearchField)
        NSLayoutConstraint.activate([
            singleSearchField.topAnchor.constraint(equalTo: multiSearchField.bottomAnchor, constant: 20),
            singleSearchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            singleSearchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.singleSearchField = singleSearchField

        let comboField = TextField()
        comboField.translatesAutoresizingMaskIntoConstraints = false
        comboField.delegate = self
        comboField.labelText = "Single Select"
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
        comboField.inputAccessoryView = inputAccessoryView
        comboField.tag = tag
        tag += 1
        scrollView.addSubview(comboField)
        NSLayoutConstraint.activate([
            comboField.topAnchor.constraint(equalTo: singleSearchField.bottomAnchor, constant: 20),
            comboField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            comboField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: comboField.bottomAnchor, constant: 20)
        ])
        self.comboField = comboField
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

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
}
