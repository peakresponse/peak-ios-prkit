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

    @IBInspectable override var text: String? {
        get { return textField.text }
        set { textField.text = newValue}
    }

    @IBInspectable var placeholderText: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }

    override func commonInit() {
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
        delegate?.formFieldDidChange?(self)
    }

    override func updateStyle() {
        super.updateStyle()
        textField.textColor = isUserInteractionEnabled ? .base800 : .base300
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
        return delegate?.formFieldShouldBeginEditing?(self) ?? true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.formFieldDidBeginEditing?(self)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.formFieldShouldEndEditing?(self) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.formFieldDidEndEditing?(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
