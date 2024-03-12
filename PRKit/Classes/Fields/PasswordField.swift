//
//  TextField.swift
//  PRKit
//
//  Created by Francis Li on 9/4/20.
//

import UIKit

private class InternalTextField: UITextField {
    weak var passwordField: PasswordField?

    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            passwordField?.updateStyle()
            passwordField?.reloadInputViews()
            return true
        }
        return false
    }

    override func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            passwordField?.updateStyle()
            return true
        }
        return false
    }
}

@IBDesignable
open class PasswordField: FormField, UITextFieldDelegate {
    let textField: UITextField = InternalTextField()

    @IBInspectable override open var text: String? {
        get { return textField.text }
        set { textField.text = newValue}
    }

    @IBInspectable open var placeholderText: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }

    private var _inputAccessoryView: UIView?
    open override var inputAccessoryView: UIView? {
        get { return _inputAccessoryView }
        set { _inputAccessoryView = newValue }
    }

    override open func commonInit() {
        super.commonInit()

        textField.delegate = self
        (textField as? InternalTextField)?.passwordField = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .h4SemiBold
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .valueChanged)
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            textField.leftAnchor.constraint(equalTo: label.leftAnchor),
            textField.rightAnchor.constraint(equalTo: label.rightAnchor),
            textField.heightAnchor.constraint(equalToConstant: round(textField.font!.lineHeight * 1.2)),
            contentView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8)
        ])
    }

    @objc func textFieldDidChange() {
        delegate?.formComponentDidChange?(self)
    }

    override open func updateStyle() {
        super.updateStyle()
        textField.textColor = isEnabled ? .base800 : .base300
    }

    open override var canBecomeFirstResponder: Bool {
        return isEnabled && textField.canBecomeFirstResponder
    }

    override open var isFirstResponder: Bool {
        return textField.isFirstResponder
    }

    override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override open func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    // MARK: - UITextViewDelegate

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return (delegate as? FormFieldDelegate)?.formFieldShouldBeginEditing?(self) ?? true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        (delegate as? FormFieldDelegate)?.formFieldDidBeginEditing?(self)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return (delegate as? FormFieldDelegate)?.formFieldShouldEndEditing?(self) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        (delegate as? FormFieldDelegate)?.formFieldDidEndEditing?(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (delegate as? FormFieldDelegate)?.formFieldShouldReturn?(self) ?? true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
