//
//  AutocompleteTextField.swift
//  PRKit
//
//  Created by Francis Li on 5/27/26.
//

import Foundation
import UIKit

class AutocompleteDropdownView: UIView, UITableViewDataSource, UITableViewDelegate {
    weak var textField: AutocompleteTextField!
    var stackView: UIStackView!
    var segmentedControl: SegmentedControl?
    var tableView: TableView!

    init(textField: AutocompleteTextField) {
        self.textField = textField
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func commonInit() {
        backgroundColor = .clear
        addShadow(withOffset: .zero, radius: 4, color: .black, opacity: 0.25)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        if textField.sources.count > 1 {
            let segmentedControl = SegmentedControl()
            for source in textField.sources {
                segmentedControl.addSegment(title: source.name)
            }
            stackView.addArrangedSubview(segmentedControl)
        }

        tableView = TableView()
        tableView.backgroundColor = .white
        tableView.layer.borderColor = UIColor.focusedBorder.cgColor
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "Item")
        stackView.addArrangedSubview(tableView)
    }

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textField.sources[textField.sourceIndex].count()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        if let cell = cell as? CheckboxTableViewCell, let value = textField.sources[textField.sourceIndex].value(at: indexPath.row) {
            cell.checkbox.isRadioButton = !textField.isMultiSelect
            cell.checkbox.labelText = textField.sources[textField.sourceIndex].title(at: indexPath.row)
            cell.checkbox.isUserInteractionEnabled = false
            if textField.isMultiSelect {
                let values = textField.attributeValue as? [NSObject] ?? []
                cell.checkbox.isChecked = values.contains(value)
            } else {
                cell.checkbox.isChecked = textField.attributeValue == value
            }
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? CheckboxTableViewCell, let value = textField.sources[textField.sourceIndex].value(at: indexPath.row) {
            if cell.checkbox.isChecked {
                cell.checkbox.isChecked = false
                if textField.isMultiSelect {
                    if var values = textField.attributeValue as? [NSObject], let index = values.firstIndex(of: value) {
                        values.remove(at: index)
                        textField.attributeValue = values as NSObject
                    } else {
                        textField.attributeValue = [] as NSObject
                    }
                } else {
                    textField.attributeValue = nil
                }
            } else {
                cell.checkbox.isChecked = true
                if textField.isMultiSelect {
                    if var values = textField.attributeValue as? [NSObject] {
                        values.append(value)
                        textField.attributeValue = values as NSObject
                    } else {
                        textField.attributeValue = [value] as NSObject
                    }
                } else {
                    textField.attributeValue = value
                    textField.text = cell.checkbox.labelText
                    for otherIndexPath in tableView.indexPathsForVisibleRows ?? [] {
                        if otherIndexPath != indexPath, let otherCell = tableView.cellForRow(at: otherIndexPath) as? CheckboxTableViewCell {
                            otherCell.checkbox.isChecked = false
                        }
                    }
                    textField.hideDropdown()
                    textField.delegate?.formComponentDidChange?(textField)
                }
            }
        }
    }
}

open class AutocompleteTextField: TextField {
    public var isMultiSelect = false
    public var sources: [KeyboardSource] = []
    public var sourceIndex = 0

    var dropdownView: AutocompleteDropdownView?

    override open func updateStyle() {
        super.updateStyle()
        clearButton.isHidden = (text?.isEmpty ?? true) || !isEnabled
        _placeholderLabel?.isHidden = !(text?.isEmpty ?? true)
    }

    open override func clearPressed(_ sender: UIButton? = nil) {
        super.clearPressed(sender)
        textViewDidChange(textView)
        if isFirstResponder {
            showDropdown()
        }
    }

    func showDropdown() {
        if dropdownView == nil {
            let dropdownView = AutocompleteDropdownView(textField: self)
            dropdownView.translatesAutoresizingMaskIntoConstraints = false
            var superview: UIView? = superview
            while !(superview is UIScrollView) && superview != nil {
                superview = superview?.superview
            }
            if let scrollView = superview as? UIScrollView {
                scrollView.isScrollEnabled = false
                scrollView.contentInset = .init(top: 0, left: 0, bottom: scrollView.frame.height, right: 0)
                scrollView.setContentOffset(CGPoint(x: 0, y: -(scrollView.safeAreaInsets.top - frame.origin.y)), animated: true)
                scrollView.addSubview(dropdownView)
                NSLayoutConstraint.activate([
                    dropdownView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 14),
                    dropdownView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    dropdownView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    dropdownView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -4),
                ])
            }
            self.dropdownView = dropdownView
        }
    }
    
    func hideDropdown() {
        var superview: UIView? = superview
        while !(superview is UIScrollView) && superview != nil {
            superview = superview?.superview
        }
        if let scrollView = superview as? UIScrollView {
            scrollView.contentInset = .zero
            scrollView.isScrollEnabled = true
        }
        dropdownView?.removeFromSuperview()
        dropdownView = nil
    }

    // MARK: - NSTextStorageDelegate

    override public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange, changeInLength delta: Int) {
        super.textStorage(textStorage, didProcessEditing: editedMask, range: editedRange, changeInLength: delta)
        if editedMask.contains(.editedCharacters) {
            _placeholderLabel?.isHidden = !(text?.isEmpty ?? true)
            clearButton.isHidden = (text?.isEmpty ?? true) || !isEnabled
        }
    }

    // MARK: - UITextViewDelegate

    override public func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
        showDropdown()
    }

    public override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !isMultiSelect && attributeValue != nil {
            attributeValue = nil
            if text == "" {
                textViewDidChange(textView)
            }
            showDropdown()
        }
        return true
    }

    override public func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty {
            sources[sourceIndex].search(text, callback: nil)
        } else {
            sources[sourceIndex].search(nil, callback: nil)
        }
        dropdownView?.tableView.reloadData()
    }

    override public func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        hideDropdown()
        if isMultiSelect || attributeValue == nil {
            text = nil
        }
        sources[sourceIndex].search(nil, callback: nil)
    }
}
