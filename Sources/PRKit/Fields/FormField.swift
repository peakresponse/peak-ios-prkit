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

    var buttonLabel: String {
        switch self {
        case .integer, .integerWithUnit(_), .decimal, .decimalWithUnit(_):
            return "Button.123".localized
        case .date, .datetime:
            return "Button.date".localized
        case .picker(let source), .single(let source), .multi(let source):
            if let name = source?.name, !name.isEmpty {
                return name
            }
            return "Button.select".localized
        default:
            return "Button.abc".localized
        }
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
    open weak var stackView: UIStackView!
    open weak var contentStackView: UIStackView!
    open weak var contentView: UIView!
    var multiValueViews: [UIView]?

    open weak var statusButton: UIButton!
    open weak var accessoryButton: UIButton?
    open var accessoryButtonImage: UIImage? {
        get { return accessoryButton?.image(for: .normal) }
        set {
            initAccessoryButton()
            accessoryButton?.setImage(newValue, for: .normal)
        }
    }

    open weak var label: UILabel!
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

    open var attributeIndex: Int = 0 {
        didSet {
            updateAttributeType()
        }
    }
    open var attributeTypes: [FormFieldAttributeType] = [.text] {
        didSet {
            attributeValues = [NSObject?](repeating: nil, count: attributeTypes.count)
            updateAttributeType()
        }
    }
    open var attributeType: FormFieldAttributeType {
        get { return attributeTypes[attributeIndex] }
        set {
            attributeTypes[attributeIndex] = newValue
            updateAttributeType()
        }
    }
    @IBInspectable open var AttributeType: String {
        get { return attributeType.rawValue }
        set { attributeType = FormFieldAttributeType(rawValue: newValue) ?? .text }
    }

    open var attributeValues: [NSObject?] = [nil] {
        didSet {
            didUpdateAttributeValue()
        }
    }
    open override var attributeValue: NSObject? {
        get { return attributeValues[attributeIndex] }
        set {
            attributeValues[attributeIndex] = newValue
            for (i, _) in attributeValues.enumerated() where i != attributeIndex {
                attributeValues[i] = nil
            }
        }
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
        self.stackView = stackView

        let statusButton = UIButton()
        statusButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        statusButton.backgroundColor = .border
        stackView.addArrangedSubview(statusButton)
        self.statusButton = statusButton
        
        let view = UIView()
        stackView.addArrangedSubview(view)
        
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 2
        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
        ])
        self.contentStackView = contentStackView

        let label = UILabel()
        contentStackView.addArrangedSubview(label)
        self.label = label

        let contentView = UIView()
        contentStackView.addArrangedSubview(contentView)
        self.contentView = contentView
    }

    private func initAccessoryButton() {
        if accessoryButton != nil {
            return
        }
        let accessoryButton = UIButton()
        accessoryButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        accessoryButton.setBackgroundImage(.resizableImage(withColor: .primaryButtonNormal, cornerRadius: 8, corners: [.topRight, .bottomRight]), for: .normal)
        accessoryButton.setBackgroundImage(.resizableImage(withColor: .primaryButtonHighlighted, cornerRadius: 8, corners: [.topRight, .bottomRight]), for: .highlighted)
        accessoryButton.setBackgroundImage(.resizableImage(withColor: .primaryButtonDisabled, cornerRadius: 8, corners: [.topRight, .bottomRight]), for: .disabled)
        accessoryButton.tintColor = .primaryButtonTint

        stackView.addArrangedSubview(accessoryButton)
        self.accessoryButton = accessoryButton
    }

    private func initErrorLabel() {
        _errorLabel = UILabel()
        _errorLabel.translatesAutoresizingMaskIntoConstraints = false
        _errorLabel.font = .body14Bold
        _errorLabel.numberOfLines = 0
        _errorLabel.textColor = .error
        _errorLabel.isHidden = !hasError
        contentStackView.addArrangedSubview(_errorLabel)
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
        var text: String = ""
        if let multiValueViews {
            for view in multiValueViews {
                view.removeFromSuperview()
            }
            self.multiValueViews?.removeAll()
        }
        if let values = attributeValues.first as? [NSObject?], !values.isEmpty {
            let values = values.compactMap({ attributeTypes[0].text(for: $0)})
            if !values.isEmpty {
                for (i, value) in values.enumerated() {
                    if i == values.count - 1 {
                        self.text = value
                    } else {
                        if multiValueViews == nil {
                            multiValueViews = []
                        }
                        let valueView = UIView()
                        multiValueViews?.append(valueView)
                        contentStackView.insertArrangedSubview(valueView, at: 2)

                        let valueSeparatorView = UIView()
                        valueSeparatorView.translatesAutoresizingMaskIntoConstraints = false
                        valueSeparatorView.backgroundColor = .disabledBorder
                        valueView.addSubview(valueSeparatorView)
                        NSLayoutConstraint.activate([
                            valueSeparatorView.topAnchor.constraint(equalTo: valueView.topAnchor, constant: (i == values.count - 2) ? 2 : 0),
                            valueSeparatorView.leftAnchor.constraint(equalTo: valueView.leftAnchor),
                            valueSeparatorView.rightAnchor.constraint(equalTo: valueView.rightAnchor),
                            valueSeparatorView.heightAnchor.constraint(equalToConstant: 2)
                        ])

                        let valueLabel = UILabel()
                        valueLabel.translatesAutoresizingMaskIntoConstraints = false
                        valueLabel.font = .h4SemiBold
                        valueLabel.numberOfLines = 0
                        let attributedText = NSMutableAttributedString(string: value)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 4
                        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: attributedText.length))
                        valueLabel.attributedText = attributedText

                        valueLabel.textColor = .text
                        valueView.addSubview(valueLabel)
                        NSLayoutConstraint.activate([
                            valueLabel.topAnchor.constraint(equalTo: valueSeparatorView.bottomAnchor, constant: 10),
                            valueLabel.leadingAnchor.constraint(equalTo: valueView.leadingAnchor),
                            valueLabel.trailingAnchor.constraint(equalTo: valueView.trailingAnchor, constant: -44),
                            valueLabel.bottomAnchor.constraint(equalTo: valueView.bottomAnchor, constant: -10)
                        ])

                        let valueClearButton = UIButton(type: .custom)
                        valueClearButton.translatesAutoresizingMaskIntoConstraints = false
                        valueClearButton.setImage(UIImage(named: "Exit24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
                        valueClearButton.imageView?.tintColor = .labelText
                        valueClearButton.addTarget(self, action: #selector(clearPressed(_:)), for: .touchUpInside)
                        valueView.addSubview(valueClearButton)
                        NSLayoutConstraint.activate([
                            valueClearButton.widthAnchor.constraint(equalToConstant: 44),
                            valueClearButton.heightAnchor.constraint(equalToConstant: 44),
                            valueClearButton.rightAnchor.constraint(equalTo: valueView.rightAnchor, constant: 12),
                            valueClearButton.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor)
                        ])
                    }
                }
                return
            }
        }
        text = attributeValues.enumerated().compactMap { attributeTypes[$0].text(for: $1) }.joined(separator: " ")
        self.text = text.isEmpty ? nil : text
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

    @objc open func clearPressed(_ sender: UIButton? = nil) {
        if let sender, let multiValueViews, var values = attributeValues[0] as? [NSObject?] {
            var found = false
            for (i, view) in multiValueViews.enumerated() where sender.isDescendant(of: view) {
                found = true
                values.remove(at: i)
                break
            }
            if !found {
                values.removeLast()
            }
            attributeValues[0] = values as NSObject
            delegate?.formComponentDidChange?(self)
            reloadInputViews()
            return
        }
        attributeValues = .init(repeating: nil, count: attributeTypes.count)
        text = nil
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
