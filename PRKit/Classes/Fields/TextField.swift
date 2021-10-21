//
//  TextField.swift
//  PRKit
//
//  Created by Francis Li on 9/4/20.
//

import UIKit

private class InternalTextView: UITextView {
    weak var textField: TextField?

    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            textField?.updateStyle()
            return true
        }
        return false
    }

    override func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            textField?.updateStyle()
            return true
        }
        return false
    }
}

@IBDesignable
open class TextField: FormField, NSTextStorageDelegate, UITextViewDelegate {
    open var textView: UITextView!
    open var textViewHeightConstraint: NSLayoutConstraint!

    @IBInspectable open override var text: String? {
        get { return textView.text }
        set { textView.text = newValue}
    }

    private var _placeholderLabel: UILabel!
    open var placeholderLabel: UILabel {
        if _placeholderLabel == nil {
            initPlaceholderLabel()
        }
        return _placeholderLabel
    }

    @IBInspectable open var placeholderText: String? {
        get { return _placeholderLabel?.text }
        set { placeholderLabel.text = newValue }
    }

    private func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let text = text as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let rect = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin, attributes: [
                                        .font: font,
                                        .paragraphStyle: paragraphStyle
                                     ], context: nil)
        return max(font.lineHeight * 1.2, ceil(rect.height / (font.lineHeight * 1.2)) * font.lineHeight * 1.2)
    }

    override open func commonInit() {
        super.commonInit()

        let textView = InternalTextView()
        textView.delegate = self
        textView.textField = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textStorage.delegate = self
        textView.font = .h4SemiBold
        contentView.addSubview(textView)
        self.textView = textView

        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: round(textView.font!.lineHeight * 1.2))

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            textView.leftAnchor.constraint(equalTo: label.leftAnchor),
            textView.rightAnchor.constraint(equalTo: label.rightAnchor),
            textViewHeightConstraint,
            contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8)
        ])
    }

    private func initPlaceholderLabel() {
        guard _placeholderLabel == nil else { return }
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = textView.font
        placeholderLabel.textColor = .base300
        placeholderLabel.isHidden = !(text?.isEmpty ?? true)
        contentView.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            placeholderLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: label.rightAnchor)
        ])
        _placeholderLabel = placeholderLabel
    }

    override open func updateStyle() {
        super.updateStyle()
        textView.textColor = isUserInteractionEnabled ? .base800 : .base300
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
    }

    override open var isFirstResponder: Bool {
        return textView.isFirstResponder
    }

    override open func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    override open func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    // MARK: - NSTextStorageDelegate

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            _placeholderLabel?.isHidden = !(text?.isEmpty ?? true)
        }
    }

    // MARK: - UITextViewDelegate

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.formFieldShouldBeginEditing?(self) ?? true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.formFieldDidBeginEditing?(self)
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.formFieldShouldEndEditing?(self) ?? true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.formFieldDidEndEditing?(self)
    }

    public func textViewDidChange(_ textView: UITextView) {
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        textView.attributedText = NSAttributedString(string: textView.text ?? "", attributes: [
            .font: textView.font!,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textView.textColor!
        ])
        delegate?.formFieldDidChange?(self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && !(delegate?.formFieldShouldReturn?(self) ?? true) {
            return false
        }
        return true
    }
}
