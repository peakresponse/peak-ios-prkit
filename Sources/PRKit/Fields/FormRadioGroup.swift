//
//  FormRadioGroup.swift
//  PRKit
//
//  Created by Francis Li on 3/5/24.
//

import Foundation
import UIKit

@IBDesignable
open class FormRadioGroup: FormComponent, CheckboxDelegate {
    open weak var label: UILabel!
    @IBInspectable open var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    open var bottomConstraint: NSLayoutConstraint!
    open var checkboxes: [Checkbox] = []
    open var isDeselectable = false {
        didSet {
            for cb in checkboxes {
                cb.isRadioButtonDeselectable = isDeselectable
            }
        }
    }

    open var isDismissingFirstResponderOnChange = true
    private var _inputAccessoryView: UIView?
    open override var inputAccessoryView: UIView? {
        get { return _inputAccessoryView }
        set { _inputAccessoryView = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .clear

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.textColor = .base500
        addSubview(label)
        bottomConstraint = bottomAnchor.constraint(equalTo: label.bottomAnchor)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            bottomConstraint
        ])
        self.label = label
    }

    open func addRadioButton(labelText: String, value: NSObject?) {
        let checkbox = Checkbox()
        checkbox.delegate = self
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.labelText = labelText
        checkbox.value = value
        checkbox.isChecked = value == attributeValue
        checkbox.isRadioButton = true
        checkbox.isRadioButtonDeselectable = isDeselectable
        addSubview(checkbox)
        bottomConstraint.isActive = false
        bottomConstraint = bottomAnchor.constraint(equalTo: checkbox.bottomAnchor)
        if checkboxes.count == 0 {
            NSLayoutConstraint.activate([
                checkbox.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
                checkbox.leftAnchor.constraint(equalTo: label.leftAnchor),
                checkbox.rightAnchor.constraint(equalTo: label.rightAnchor),
                bottomConstraint
            ])
        } else if let last = checkboxes.last {
            NSLayoutConstraint.activate([
                checkbox.topAnchor.constraint(equalTo: last.bottomAnchor, constant: 12),
                checkbox.leftAnchor.constraint(equalTo: last.leftAnchor),
                checkbox.rightAnchor.constraint(equalTo: last.rightAnchor),
                bottomConstraint
            ])
        }
        checkboxes.append(checkbox)
    }

    open override func didUpdateAttributeValue() {
        for cb in checkboxes {
            cb.isChecked = cb.value == attributeValue
        }
    }

    // MARK: - CheckboxDelegate

    public func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool) {
        if isDismissingFirstResponderOnChange, let inputAccessoryView = inputAccessoryView as? FormInputAccessoryView {
            inputAccessoryView.donePressed()
        }
        attributeValue = isChecked ? checkbox.value : nil
        delegate?.formComponentDidChange?(self)
    }
}
