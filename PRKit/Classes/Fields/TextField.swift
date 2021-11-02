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
    open weak var textView: UITextView!
    open weak var textViewHeightConstraint: NSLayoutConstraint!

    open weak var _iconView: UIImageView!
    open var iconView: UIImageView {
        if _iconView == nil {
            initIconView()
        }
        return _iconView
    }
    @IBInspectable open var isSearchIconHidden: Bool {
        get { return _iconView?.isHidden ?? true }
        set { iconView.image = UIImage(named: "Search24px", in: Bundle(for: type(of: self)), compatibleWith: nil)}
    }

    open weak var clearButton: UIButton!

    @IBInspectable open override var text: String? {
        get { return textView.text }
        set { textView.text = newValue}
    }

    private weak var _placeholderLabel: UILabel!
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
        let textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: round(textView.font!.lineHeight * 1.2))
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            textView.leftAnchor.constraint(equalTo: label.leftAnchor),
            textView.rightAnchor.constraint(equalTo: label.rightAnchor),
            textViewHeightConstraint,
            contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8)
        ])
        self.textView = textView
        self.textViewHeightConstraint = textViewHeightConstraint

        let clearButton = UIButton(type: .custom)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(named: "Exit24px", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        clearButton.imageView?.tintColor = .base800
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        contentView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
        self.clearButton = clearButton
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

    private func initIconView() {
        guard _iconView == nil else { return }
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .base800
        iconView.contentMode = .center
        iconView.isHidden = !(text?.isEmpty ?? true)
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            iconView.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: -1)
        ])
        _iconView = iconView
    }

    override open func updateStyle() {
        super.updateStyle()
        textView.textColor = isUserInteractionEnabled ? .base800 : .base300
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
        let isEmpty = text?.isEmpty ?? true
        clearButton.isHidden = isEmpty || !isUserInteractionEnabled
        _iconView?.isHidden = !isEmpty
        _placeholderLabel?.isHidden = !isEmpty
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
            let isEmpty = text?.isEmpty ?? true
            _placeholderLabel?.isHidden = !isEmpty
            _iconView?.isHidden = !isEmpty
            clearButton.isHidden = isEmpty || !isUserInteractionEnabled
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
