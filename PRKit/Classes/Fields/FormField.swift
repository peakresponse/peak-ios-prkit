//
//  FormField.swift
//  PRKit
//
//  Created by Francis Li on 9/24/21.
//

import UIKit

@objc public protocol FormFieldDelegate: FormComponentDelegate {
    @objc optional func formFieldShouldBeginEditing(_ field: FormField) -> Bool
    @objc optional func formFieldDidBeginEditing(_ field: FormField)
    @objc optional func formFieldShouldEndEditing(_ field: FormField) -> Bool
    @objc optional func formFieldDidEndEditing(_ field: FormField)
    @objc optional func formFieldShouldReturn(_ field: FormField) -> Bool
    @objc optional func formFieldDidPress(_ field: FormField)
    @objc optional func formFieldDidPressOther(_ field: FormField)
    @objc optional func formFieldDidPressStatus(_ field: FormField)
    @objc optional func formField(_ field: FormField, wantsToPresent vc: UIViewController)
}

public enum FormFieldAttributeType: Equatable {
    case text
    case integer, integerWithUnit(KeyboardSource? = nil)
    case decimal, decimalWithUnit(KeyboardSource? = nil)
    case date, datetime
    case picker(KeyboardSource? = nil)
    case single(KeyboardSource? = nil)
    case multi(KeyboardSource? = nil)
    case custom(FormInputView? = nil)

    var rawValue: String {
        return String(describing: self)
    }

    init?(rawValue: String) {
        switch rawValue {
        case "text":
            self = .text
        case "integer":
            self = .integer
        case "integerWithUnit":
            self = .integerWithUnit()
        case "decimal":
            self = .decimal
        case "decimalWithUnit":
            self = .decimalWithUnit()
        case "date":
            self = .date
        case "datetime":
            self = .datetime
        case "picker":
            self = .picker()
        case "single":
            self = .single()
        case "multi":
            self = .multi()
        case "custom":
            self = .custom()
        default:
            return nil
        }
    }

    var inputView: FormInputView? {
        switch self {
        case .integer, .decimal:
            return NumberKeypad.instance
        case .integerWithUnit(_), .decimalWithUnit(_):
            return NumberAndUnitKeypad.instance
        case .date:
            return DateKeyboard.instance
        case .datetime:
            return DateTimeKeyboard.instance
        case .picker(_):
            return PickerKeyboard.instance
        case .single(_), .multi(_):
            return SelectKeyboard.instance
        case .custom(let inputView):
            return inputView
        default:
            return nil
        }
    }

    public func configureInputView(delegate: FormInputViewDelegate?, textView: UITextView) {
        switch self {
        case .integer:
            (inputView as? NumberKeypad)?.isDecimalHidden = true
        case .decimal:
            (inputView as? NumberKeypad)?.isDecimalHidden = false
        case .integerWithUnit(let source):
            (inputView as? NumberAndUnitKeypad)?.isDecimalHidden = true
            (inputView as? NumberAndUnitKeypad)?.unitSource = source
        case .decimalWithUnit(let source):
            (inputView as? NumberAndUnitKeypad)?.isDecimalHidden = false
            (inputView as? NumberAndUnitKeypad)?.unitSource = source
        case .picker(let source):
            (inputView as? PickerKeyboard)?.source = source
        case .single(let source):
            (inputView as? SelectKeyboard)?.isMultiSelect = false
            (inputView as? SelectKeyboard)?.source = source
        case .multi(let source):
            (inputView as? SelectKeyboard)?.isMultiSelect = true
            (inputView as? SelectKeyboard)?.source = source
        default:
            break
        }
        inputView?.delegate = delegate
        inputView?.textView = textView
    }

    public func text(for value: NSObject?) -> String? {
        switch self {
        case .date:
            return ISO8601DateFormatter.date(from: value as? String)?.asDateString()
        case .datetime:
            return (value as? Date)?.asDateTimeString()
        case .integerWithUnit(_), .decimalWithUnit(_):
            if let value = value as? [String?], value.count > 0 {
                return value[0]
            }
            return nil
        case .picker(let source), .single(let source), .multi(let source):
            if let value = value as? [NSObject] {
                return value.compactMap({ text(for: $0) }).joined(separator: "\n")
            }
            return source?.title(for: value)
        case .custom(let inputView):
            return inputView?.text(for: value)
        default:
            return value as? String
        }
    }

    public func unitText(for value: NSObject?) -> String? {
        switch self {
        case .integerWithUnit(let source), .decimalWithUnit(let source):
            if let value = value as? [NSObject?], value.count == 2, let unit = source?.title(for: value[1]) {
                return " \(unit)"
            }
        default:
            break
        }
        return nil
    }

    public static func == (lhs: FormFieldAttributeType, rhs: FormFieldAttributeType) -> Bool {
        switch (lhs, rhs) {
        case (.text, .text):
            return true
        case (.integer, .integer):
            return true
        case (.integerWithUnit, .integerWithUnit):
            return true
        case (.decimal, .decimal):
            return true
        case (.decimalWithUnit, .decimalWithUnit):
            return true
        case (.date, .date):
            return true
        case (.datetime, .datetime):
            return true
        case (.picker, .picker):
            return true
        case (.single, .single):
            return true
        case (.multi, .multi):
            return true
        case (.custom, .custom):
            return true
        default:
            return false
        }
    }
}

open class FormField: FormComponent, Localizable, FormInputViewDelegate {
    open weak var borderedView: UIView!
    open weak var contentView: UIView!

    open weak var statusButton: UIButton!
    open var statusButtonWidthConstraint: NSLayoutConstraint!

    open weak var label: UILabel!
    open weak var labelHeightConstraint: NSLayoutConstraint!
    @IBInspectable open var l10nKey: String? {
        get { return nil }
        set { label.l10nKey = newValue }
    }
    @IBInspectable open var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    @IBInspectable open var isLabelHidden: Bool {
        get { return label.isHidden }
        set {
            label.isHidden = newValue
            labelHeightConstraint.constant = newValue ? 4 : 28
        }
    }

    private var _errorLabel: UILabel!
    open var errorLabel: UILabel {
        if _errorLabel == nil {
            initErrorLabel()
        }
        return _errorLabel
    }

    @objc open var text: String? {
        didSet {
            updateStyle()
        }
    }

    open var attributeType: FormFieldAttributeType = .text {
        didSet { updateAttributeType() }
    }
    @IBInspectable open var AttributeType: String {
        get { return attributeType.rawValue }
        set { attributeType = FormFieldAttributeType(rawValue: newValue) ?? .text }
    }
    open var inputAccessoryViewOtherButtonTitle: String?

    open var isEmpty: Bool {
        if (text?.isEmpty ?? true) && ((attributeValue as? String)?.isEmpty ?? (attributeValue == nil)) {
            return true
        }
        if let attributeValues = attributeValue as? [NSObject] {
            return attributeValues.reduce(into: true) { (partialResult, value) in
                partialResult = partialResult && ((value as? String)?.isEmpty ?? (value == NSNull()))
            }
        }
        return false
    }

    @IBInspectable open var isPlainText: Bool = false {
        didSet { updateStyle() }
    }

    @IBInspectable open var hasError: Bool = false {
        didSet { updateStyle() }
    }
    @IBInspectable open var errorText: String? {
        get { return _errorLabel?.text }
        set { errorLabel.text = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateStyle()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        updateStyle()
    }

    open func commonInit() {
        backgroundColor = .clear

        let borderedView = UIView()
        borderedView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderedView)
        NSLayoutConstraint.activate([
            borderedView.topAnchor.constraint(equalTo: topAnchor),
            borderedView.leftAnchor.constraint(equalTo: leftAnchor),
            rightAnchor.constraint(equalTo: borderedView.rightAnchor),
            bottomAnchor.constraint(equalTo: borderedView.bottomAnchor)
        ])
        self.borderedView = borderedView

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        borderedView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: borderedView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: borderedView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: borderedView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor)
        ])

        let statusButton = UIButton()
        statusButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        stackView.addArrangedSubview(statusButton)
        self.statusButton = statusButton

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(contentView)
        self.contentView = contentView

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 28)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            labelHeightConstraint
        ])
        self.label = label
        self.labelHeightConstraint = labelHeightConstraint
    }

    private func initErrorLabel() {
        _errorLabel = UILabel()
        _errorLabel.translatesAutoresizingMaskIntoConstraints = false
        _errorLabel.font = .body14Bold
        _errorLabel.numberOfLines = 0
        _errorLabel.textColor = .error
        _errorLabel.isHidden = !hasError
        addSubview(_errorLabel)

        let bottomConstraint = bottomAnchor.constraint(equalTo: _errorLabel.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            _errorLabel.topAnchor.constraint(equalTo: borderedView.bottomAnchor, constant: 4),
            _errorLabel.heightAnchor.constraint(equalToConstant: 18),
            _errorLabel.leftAnchor.constraint(equalTo: borderedView.leftAnchor, constant: 16),
            _errorLabel.rightAnchor.constraint(equalTo: borderedView.rightAnchor, constant: -16),
            bottomConstraint
        ])
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if isFirstResponder {
            borderedView.addOutline(size: 4, color: .highlight, opacity: 1)
        }
    }

    open func updateAttributeType() {

    }

    open override func didUpdateAttributeValue() {
        super.didUpdateAttributeValue()
        text = attributeType.text(for: attributeValue)
    }

    open override func didUpdateEnabled() {
        contentView.isUserInteractionEnabled = isEnabled
        updateStyle()
    }

    open override func updateStyle() {
        if isPlainText {
            borderedView.backgroundColor = .clear
            borderedView.layer.borderWidth = 0
        } else {
            borderedView.backgroundColor = .textBackground
            borderedView.layer.borderWidth = 2
            borderedView.layer.cornerRadius = 8
            if hasError {
                borderedView.layer.borderColor = UIColor.error.cgColor
                if isFirstResponder {
                    borderedView.addOutline(size: 4, color: .errorHighlight, opacity: 1)
                } else {
                    borderedView.removeOutline()
                }
            } else if isFirstResponder {
                borderedView.layer.borderColor = UIColor.focusedBorder.cgColor
                borderedView.addOutline(size: 4, color: .highlight, opacity: 1)
            } else {
                borderedView.layer.borderColor = (isEnabled ?
                    (isEmpty ? UIColor.emptyBorder : UIColor.border) :
                    UIColor.disabledBorder).cgColor
                borderedView.removeOutline()
            }
        }

        label.font = .h4SemiBold
        label.textColor = hasError ? .error : (isFirstResponder ?
            .focusedLabelText :
            (isEnabled ? .labelText : .disabledLabelText))

        _errorLabel?.isHidden = !hasError

        statusButton.backgroundColor = .border
        if status != .none {
            if statusButton.image(for: .normal) == nil {
                statusButton.setImage(UIImage.image(withColor: .focusedBorder, cornerRadius: 16,
                                                    iconImage: UIImage(named: "Voice24px", in: PRKitBundle.instance, compatibleWith: nil),
                                                    iconTintColor: .white),
                                      for: .normal)
            }
            statusButton.isHidden = false
        } else {
            statusButton.setImage(nil, for: .normal)
            statusButton.isHidden = true
        }
    }

    open override func reloadInputViews() {
        inputView?.reloadInputViews()
        if let inputView = inputView as? FormInputView {
            inputView.setValue(attributeValue)
        }
        if let inputAccessoryView = inputAccessoryView as? FormInputAccessoryView {
            inputAccessoryView.currentView = self
        }
    }

    @objc open func clearPressed() {
        text = nil
        attributeValue = nil
        status = .none
        delegate?.formComponentDidChange?(self)
        if let inputView = inputView as? FormInputView, inputView.shouldResignAfterClear {
            resignFirstResponder()
        } else {
            reloadInputViews()
        }
    }

    @objc open func statusPressed() {
        (delegate as? FormFieldDelegate)?.formFieldDidPressStatus?(self)
    }

    // MARK: - FormInputViewDelegate

    public func formInputView(_ inputView: FormInputView, didChange value: NSObject?) {
        attributeValue = value
        delegate?.formComponentDidChange?(self)
    }

    public func formInputView(_ inputView: FormInputView, wantsToPresent vc: UIViewController) {
        (delegate as? FormFieldDelegate)?.formField?(self, wantsToPresent: vc)
    }

    // MARK: - UIResponder

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canBecomeFirstResponder {
            _ = becomeFirstResponder()
        }
    }
}
