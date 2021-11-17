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
            textField?.reloadInputViews()
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
        set {
            let text = newValue ?? ""
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            textView.attributedText = NSAttributedString(string: text, attributes: [
                .font: textView.font!,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: textView.textColor!
            ])
            textViewHeightConstraint.constant = heightForText(text, font: textView.font!, width: textView.frame.width)
        }
    }

    @IBInspectable open var isDebounced: Bool = false
    @IBInspectable open var debounceTime: Double = 0.3
    open var debounceTimer: Timer?

    private weak var _placeholderLabel: UILabel!
    open var placeholderLabel: UILabel {
        if _placeholderLabel == nil {
            initPlaceholderLabel()
        }
        return _placeholderLabel
    }

    private weak var _unitLabel: UILabel!
    open var unitLabel: UILabel {
        if _unitLabel == nil {
            initUnitLabel()
        }
        return _unitLabel
    }
    open var unitLabelLeftConstraint: NSLayoutConstraint!

    @IBInspectable open var placeholderText: String? {
        get { return _placeholderLabel?.text }
        set { placeholderLabel.text = newValue }
    }

    open override var inputView: UIView? {
        get { return textView.inputView }
        set { textView.inputView = newValue }
    }

    private var _inputAccessoryView: UIView?
    open override var inputAccessoryView: UIView? {
        get { return _inputAccessoryView }
        set { _inputAccessoryView = newValue }
    }

    open var keyboardType: UIKeyboardType {
        get { return textView.keyboardType }
        set {
            textView.keyboardType = newValue
            switch newValue {
            case .emailAddress:
                autocapitalizationType = .none
                autocorrectionType = .no
            default:
                break
            }
        }
    }

    open var keyboardAppearance: UIKeyboardAppearance {
        get { return textView.keyboardAppearance }
        set { textView.keyboardAppearance = newValue }
    }

    open var returnKeyType: UIReturnKeyType {
        get { return textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }

    open var textContentType: UITextContentType! {
        get { return textView.textContentType }
        set { textView.textContentType = newValue }
    }

    open var autocapitalizationType: UITextAutocapitalizationType {
        get { return textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }

    open var autocorrectionType: UITextAutocorrectionType {
        get { return textView.autocorrectionType }
        set { textView.autocorrectionType = newValue }
    }

    open var spellCheckingType: UITextSpellCheckingType {
        get { return textView.spellCheckingType }
        set { textView.spellCheckingType = newValue }
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

    private func widthForText(_ text: String, font: UIFont) -> CGFloat {
        let text = text as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let rect = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin, attributes: [
                                        .font: font,
                                        .paragraphStyle: paragraphStyle
                                     ], context: nil)
        return rect.width
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
        placeholderLabel.isHidden = !isEmpty
        contentView.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            placeholderLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: label.rightAnchor)
        ])
        _placeholderLabel = placeholderLabel
    }

    private func initUnitLabel() {
        guard _unitLabel == nil else { return }
        let unitLabel = UILabel()
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = textView.font
        unitLabel.textColor = .base800
        contentView.addSubview(unitLabel)
        unitLabelLeftConstraint = unitLabel.leftAnchor.constraint(equalTo: label.leftAnchor)
        NSLayoutConstraint.activate([
            unitLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            unitLabelLeftConstraint,
            unitLabel.rightAnchor.constraint(equalTo: label.rightAnchor)
        ])
        _unitLabel = unitLabel
    }

    private func initIconView() {
        guard _iconView == nil else { return }
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .base800
        iconView.contentMode = .center
        iconView.isHidden = !isEmpty
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            iconView.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: -1)
        ])
        _iconView = iconView
    }

    open override func updateAttributeType() {
        inputView = nil
        textView.isEditable = true
        switch attributeType {
        case .integer:
            var integerKeypad: NumberKeypad! = textView.inputView as? NumberKeypad
            if integerKeypad == nil {
                integerKeypad = NumberKeypad()
                integerKeypad.textView = textView
                inputView = integerKeypad
            }
            integerKeypad.delegate = self
            integerKeypad.isDecimalHidden = true
        case .decimal:
            var decimalKeypad: NumberKeypad! = textView.inputView as? NumberKeypad
            if decimalKeypad == nil {
                decimalKeypad = NumberKeypad()
                decimalKeypad.textView = textView
                inputView = decimalKeypad
            }
            decimalKeypad.delegate = self
            decimalKeypad.isDecimalHidden = false
        case .date:
            var dateKeyboard: DateKeyboard! = textView.inputView as? DateKeyboard
            if dateKeyboard == nil {
                dateKeyboard = DateKeyboard()
                inputView = dateKeyboard
            }
            dateKeyboard.delegate = self
            textView.isEditable = false
        case .datetime:
            var dateTimeKeyboard: DateTimeKeyboard! = textView.inputView as? DateTimeKeyboard
            if dateTimeKeyboard == nil {
                dateTimeKeyboard = DateTimeKeyboard()
                inputView = dateTimeKeyboard
            }
            dateTimeKeyboard.delegate = self
            textView.isEditable = false
        case .integerWithUnit(let source):
            var integerWithUnitKeyboard: NumberWithUnitKeypad! = textView.inputView as? NumberWithUnitKeypad
            if integerWithUnitKeyboard == nil {
                integerWithUnitKeyboard = NumberWithUnitKeypad()
                integerWithUnitKeyboard.textView = textView
                inputView = integerWithUnitKeyboard
            }
            integerWithUnitKeyboard.delegate = self
            integerWithUnitKeyboard.isDecimalHidden = true
            integerWithUnitKeyboard.unitSource = source
        case .picker(let source):
            var pickerKeyboard: PickerKeyboard! = textView.inputView as? PickerKeyboard
            if pickerKeyboard == nil {
                pickerKeyboard = PickerKeyboard()
                inputView = pickerKeyboard
            }
            pickerKeyboard.delegate = self
            pickerKeyboard.source = source
            textView.isEditable = false
        default:
            break
        }
    }

    open override func updateAttributeValue() {
        switch attributeType {
        case .date:
            text = ISO8601DateFormatter.date(from: attributeValue as? String)?.asDateString()
        case .datetime:
            text = (attributeValue as? Date)?.asDateTimeString()
        case .integerWithUnit(let source):
            if let value = attributeValue as? [String], value.count == 2, let unit = source?.title(for: value[1]) {
                text = value[0]
                unitLabel.text = " \(unit)"
                unitLabelLeftConstraint.constant = widthForText(text!, font: textView.font!)
            }
        case .picker(let source):
            text = source?.title(for: attributeValue as? String)
        default:
            text = attributeValue as? String
        }
    }

    override open func updateStyle() {
        super.updateStyle()
        textView.textColor = .base800
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
        clearButton.isHidden = isEmpty || !isUserInteractionEnabled
        _iconView?.isHidden = !isEmpty
        _placeholderLabel?.isHidden = !isEmpty
    }

    open override var canBecomeFirstResponder: Bool {
        return isUserInteractionEnabled && textView.canBecomeFirstResponder
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

    open override func clearPressed() {
        super.clearPressed()
        _unitLabel?.text = nil
    }

    // MARK: - NSTextStorageDelegate

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
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
        text = textView.text ?? ""
        if isDebounced {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTime, repeats: false, block: { [weak self] (_) in
                guard let self = self else { return }
                self.delegate?.formFieldDidChange?(self)
            })
        } else {
            delegate?.formFieldDidChange?(self)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && !(delegate?.formFieldShouldReturn?(self) ?? true) {
            return false
        }
        return true
    }
}
