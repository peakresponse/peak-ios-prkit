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
class TextField: BaseField, UITextViewDelegate {
    let textView: UITextView = InternalTextView()
    var textViewHeightConstraint: NSLayoutConstraint!

    @IBInspectable var isEnabled: Bool {
        get { return textView.isUserInteractionEnabled }
        set { textView.isUserInteractionEnabled = newValue }
    }

    @IBInspectable override var text: String? {
        get { return textView.text }
        set { textView.text = newValue }
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
        textView.textColor = .base800
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

    override func updateStyle() {
        super.updateStyle()
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
