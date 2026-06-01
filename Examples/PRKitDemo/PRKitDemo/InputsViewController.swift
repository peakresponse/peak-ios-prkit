//
//  InputsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/3/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Keyboardy
import PRKit
import UIKit

class InputsViewController: ViewController, FormFieldDelegate, KeyboardAwareScrollViewController {
    weak var scrollView: UIScrollView!
    weak var scrollViewBottomConstraint: NSLayoutConstraint!

    weak var autocompleteField: AutocompleteTextField!
    weak var emptyField: TextField!
    weak var disabledField: TextField!
    weak var passwordField: PasswordField!
    weak var errorField: TextField!
    weak var statusField: TextField!
    weak var radioGroup: FormRadioGroup!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Inputs"
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
        
        var items: [(String, String)] = []
        for i in 1...20 {
            items.append(("Label \(i)", "value\(i)"))
        }
        var items2: [(String, String)] = []
        for i in 1...20 {
            items2.append(("Another Label \(i)", "anothervalue\(i)"))
        }

        var autocompleteField = AutocompleteTextField()
        autocompleteField.translatesAutoresizingMaskIntoConstraints = false
        autocompleteField.delegate = self
        autocompleteField.labelText = "Autocomplete (Single)"
        autocompleteField.placeholderText = "Placeholder"
        autocompleteField.inputAccessoryView = inputAccessoryView
        autocompleteField.tag = tag
        autocompleteField.sources = [
            TupleKeyboardSource(name: "Suggested", items: items),
        ]
        tag += 1
        scrollView.addSubview(autocompleteField)
        NSLayoutConstraint.activate([
            autocompleteField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            autocompleteField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            autocompleteField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.autocompleteField = autocompleteField

        let autocompleteMultiField = AutocompleteTextField()
        autocompleteMultiField.translatesAutoresizingMaskIntoConstraints = false
        autocompleteMultiField.delegate = self
        autocompleteMultiField.labelText = "Autocomplete (Multi)"
        autocompleteMultiField.isMultiSelect = true
        autocompleteMultiField.placeholderText = "Search..."
        autocompleteMultiField.inputAccessoryView = inputAccessoryView
        autocompleteMultiField.tag = tag
        autocompleteMultiField.sources = [
            TupleKeyboardSource(name: "Suggested", items: items),
        ]
        tag += 1
        scrollView.addSubview(autocompleteMultiField)
        NSLayoutConstraint.activate([
            autocompleteMultiField.topAnchor.constraint(equalTo: autocompleteField.bottomAnchor, constant: 20),
            autocompleteMultiField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            autocompleteMultiField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        let emptyField = TextField()
        emptyField.translatesAutoresizingMaskIntoConstraints = false
        emptyField.delegate = self
        emptyField.labelText = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Dolor sit amet consectetur adipiscing elit quisque faucibus."
        emptyField.placeholderText = "Placeholder"
        emptyField.inputAccessoryView = inputAccessoryView
        emptyField.inputAccessoryViewOtherButtonTitle = "Open Tag"
        emptyField.accessoryButtonImage = UIImage(named: "Phone40px", in: PRKitBundle.instance, compatibleWith: nil)
        emptyField.tag = tag
        tag += 1
        scrollView.addSubview(emptyField)
        NSLayoutConstraint.activate([
            emptyField.topAnchor.constraint(equalTo: autocompleteMultiField.bottomAnchor, constant: 20),
            emptyField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.emptyField = emptyField
        
        let disabledField = TextField()
        disabledField.translatesAutoresizingMaskIntoConstraints = false
        disabledField.delegate = self
        disabledField.labelText = "Disabled Field"
        disabledField.placeholderText = "Placeholder"
        disabledField.inputAccessoryView = inputAccessoryView
        disabledField.isEnabled = false
        disabledField.tag = tag
        tag += 1
        scrollView.addSubview(disabledField)
        NSLayoutConstraint.activate([
            disabledField.topAnchor.constraint(equalTo: emptyField.bottomAnchor, constant: 20),
            disabledField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            disabledField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.disabledField = disabledField
        
        let passwordField = PasswordField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.delegate = self
        passwordField.labelText = "Password Field"
        passwordField.placeholderText = "********"
        passwordField.inputAccessoryView = inputAccessoryView
        passwordField.tag = tag
        tag += 1
        scrollView.addSubview(passwordField)
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: disabledField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.passwordField = passwordField
        
        let errorField = TextField()
        errorField.translatesAutoresizingMaskIntoConstraints = false
        errorField.delegate = self
        errorField.labelText = "Error Field"
        errorField.placeholderText = "Placeholder"
        errorField.hasError = true
        errorField.errorText = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Dolor sit amet consectetur adipiscing elit quisque faucibus."
        errorField.inputAccessoryView = inputAccessoryView
        errorField.tag = tag
        tag += 1
        scrollView.addSubview(errorField)
        NSLayoutConstraint.activate([
            errorField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            errorField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.errorField = errorField
        
        let checkbox = Checkbox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.labelText = "Checkbox"
        scrollView.addSubview(checkbox)
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: errorField.bottomAnchor, constant: 20),
            checkbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkbox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let disabledCheckbox = Checkbox()
        disabledCheckbox.translatesAutoresizingMaskIntoConstraints = false
        disabledCheckbox.labelText = "Disabled Checkbox"
        disabledCheckbox.isEnabled = false
        disabledCheckbox.isChecked = true
        scrollView.addSubview(disabledCheckbox)
        NSLayoutConstraint.activate([
            disabledCheckbox.topAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 20),
            disabledCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            disabledCheckbox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        let searchField = TextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.delegate = self
        searchField.isLabelHidden = true
        searchField.isSearchIconHidden = false
        searchField.placeholderText = "Search..."
        searchField.inputAccessoryView = inputAccessoryView
        searchField.tag = tag
        tag += 1
        scrollView.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: disabledCheckbox.bottomAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let radioButton = Checkbox()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.labelText = "Radio button"
        radioButton.isRadioButton = true
        scrollView.addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            radioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            radioButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let disabledRadioButton = Checkbox()
        disabledRadioButton.translatesAutoresizingMaskIntoConstraints = false
        disabledRadioButton.labelText = "Disabled radio button"
        disabledRadioButton.isRadioButton = true
        disabledRadioButton.isChecked = true
        disabledRadioButton.isEnabled = false
        scrollView.addSubview(disabledRadioButton)
        NSLayoutConstraint.activate([
            disabledRadioButton.topAnchor.constraint(equalTo: radioButton.bottomAnchor, constant: 20),
            disabledRadioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            disabledRadioButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        let radioGroup = FormRadioGroup()
        radioGroup.translatesAutoresizingMaskIntoConstraints = false
        radioGroup.inputAccessoryView = inputAccessoryView
        radioGroup.isDeselectable = true
        radioGroup.labelText = "Radio Group"
        radioGroup.addRadioButton(labelText: "Arrived", value: "arrived" as NSObject)
        radioGroup.addRadioButton(labelText: "En Route", value: "enroute" as NSObject)
        scrollView.addSubview(radioGroup)
        NSLayoutConstraint.activate([
            radioGroup.topAnchor.constraint(equalTo: disabledRadioButton.bottomAnchor, constant: 20),
            radioGroup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            radioGroup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        let statusField = TextField()
        statusField.translatesAutoresizingMaskIntoConstraints = false
        statusField.delegate = self
        statusField.labelText = "Status Field"
        statusField.placeholderText = "Placeholder"
        statusField.status = .unconfirmed
        statusField.inputAccessoryView = inputAccessoryView
        statusField.tag = tag
        tag += 1
        scrollView.addSubview(statusField)
        NSLayoutConstraint.activate([
            statusField.topAnchor.constraint(equalTo: radioGroup.bottomAnchor, constant: 20),
            statusField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        self.statusField = statusField
        
        let signatureField = SignatureField()
        signatureField.translatesAutoresizingMaskIntoConstraints = false
        signatureField.delegate = self
        scrollView.addSubview(signatureField)
        NSLayoutConstraint.activate([
            signatureField.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 20),
            signatureField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signatureField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let cellField = CellField()
        cellField.translatesAutoresizingMaskIntoConstraints = false
        cellField.isLabelHidden = true
        cellField.text = "Patient Refusal Against Medical Advice"
        scrollView.addSubview(cellField)
        NSLayoutConstraint.activate([
            cellField.topAnchor.constraint(equalTo: signatureField.bottomAnchor, constant: 20),
            cellField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cellField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        let bottomAutocompleteField = AutocompleteTextField()
        bottomAutocompleteField.translatesAutoresizingMaskIntoConstraints = false
        bottomAutocompleteField.delegate = self
        bottomAutocompleteField.labelText = "Autocomplete Field"
        bottomAutocompleteField.placeholderText = "Placeholder"
        bottomAutocompleteField.inputAccessoryView = inputAccessoryView
        bottomAutocompleteField.tag = tag
        bottomAutocompleteField.sources = [
            TupleKeyboardSource(name: "Suggested", items: items),
        ]
        tag += 1
        scrollView.addSubview(bottomAutocompleteField)
        NSLayoutConstraint.activate([
            bottomAutocompleteField.topAnchor.constraint(equalTo: cellField.bottomAnchor, constant: 20),
            bottomAutocompleteField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomAutocompleteField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: bottomAutocompleteField.bottomAnchor, constant: 20)
        ])
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
            print("changed", field.labelText ?? "", field.text ?? "", field.attributeValue ?? "nil")
        } else {
            print("changed", component.attributeKey ?? "", component.attributeValue ?? "nil")
        }
    }

    func formFieldDidPressOther(_ field: FormField) {
        print("other pressed")
    }

    func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        present(vc, animated: true)
    }
}
