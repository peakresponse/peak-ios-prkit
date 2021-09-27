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
class TextField: FormField, NSTextStorageDelegate, UITextViewDelegate {
    let textView: UITextView = InternalTextView()
    var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable override var text: String? {
        get { return textView.text }
        set { textView.text = newValue}
    }

    private var _placeholderLabel: UILabel!
    var placeholderLabel: UILabel {
        if _placeholderLabel == nil {
            initPlaceholderLabel()
        }
        return _placeholderLabel
    }
    
    @IBInspectable var placeholderText: String? {
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

    override func commonInit() {
        super.commonInit()

        textView.delegate = self
        (textView as? InternalTextView)?.textField = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textStorage.delegate = self
        textView.font = .h4SemiBold
        contentView.addSubview(textView)

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
            placeholderLabel.rightAnchor.constraint(equalTo: label.rightAnchor),
        ])
        _placeholderLabel = placeholderLabel
    }
    
    override func updateStyle() {
        super.updateStyle()
        textView.textColor = isUserInteractionEnabled ? .base800 : .base300
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
        
    }

    override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }

    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    // MARK: - NSTextStorageDelegate
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            _placeholderLabel?.isHidden = !(text?.isEmpty ?? true)
        }
    }

    // MARK: - UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.formFieldShouldBeginEditing?(self) ?? true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.formFieldDidBeginEditing?(self)
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.formFieldShouldEndEditing?(self) ?? true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.formFieldDidEndEditing?(self)
    }

    func textViewDidChange(_ textView: UITextView) {
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

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && !(delegate?.formFieldShouldReturn?(self) ?? true) {
            return false
        }
        return true
    }
}
