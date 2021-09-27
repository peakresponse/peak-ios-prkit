//
//  FormField.swift
//  PRKit
//
//  Created by Francis Li on 9/4/20.
//

import UIKit

private class FormFieldTextView: UITextView {
    weak var formField: FormField?

    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            formField?.updateStyle()
            return true
        }
        return false
    }

    override func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            formField?.updateStyle()
            return true
        }
        return false
    }
}

@IBDesignable
class FormField: BaseField, UITextViewDelegate {
    let textView: UITextView = FormFieldTextView()
    var textViewTopConstraint: NSLayoutConstraint!
    var textViewHeightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!

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
        return max(2 * font.lineHeight * 1.2, ceil(rect.height / (font.lineHeight * 1.2)) * font.lineHeight * 1.2)
    }

    override func commonInit() {
        super.commonInit()

        textView.delegate = self
        (textView as? FormFieldTextView)?.formField = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .copySBold
        textView.textColor = .mainGrey
        contentView.addSubview(textView)

        textViewTopConstraint = textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10)
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 2 * round(textView.font!.lineHeight * 1.2))
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 14)

        NSLayoutConstraint.activate([
            textViewTopConstraint,
            textView.leftAnchor.constraint(equalTo: statusButton.rightAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            textViewHeightConstraint,
            bottomConstraint
        ])
    }

    override func updateStyle() {
        super.updateStyle()
        textView.font = .copySBold
        textViewTopConstraint.constant = 4
        bottomConstraint.constant = 12

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
        updateStyle()
        delegate?.formFieldDidBeginEditing?(self)
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.formFieldShouldEndEditing?(self) ?? true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateStyle()
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
