//
//  FormField.swift
//  PRKit
//
//  Created by Francis Li on 9/24/21.
//

import UIKit

@objc public protocol FormFieldDelegate {
    @objc optional func formFieldShouldBeginEditing(_ field: FormField) -> Bool
    @objc optional func formFieldDidBeginEditing(_ field: FormField)
    @objc optional func formFieldShouldEndEditing(_ field: FormField) -> Bool
    @objc optional func formFieldDidEndEditing(_ field: FormField)
    @objc optional func formFieldShouldReturn(_ field: FormField) -> Bool
    @objc optional func formFieldDidChange(_ field: FormField)
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

open class FormField: UIView, Localizable, FormInputViewDelegate {
    open weak var borderedView: UIView!
    open weak var contentView: UIView!

    open var status: PredictionStatus = .none {
        didSet { if status != oldValue { updateStyle() } }
    }
    @IBInspectable open var Status: String? {
        get { status.rawValue }
        set { status = PredictionStatus(rawValue: newValue ?? "") ?? .none }
    }
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

    @IBOutlet open weak var delegate: FormFieldDelegate?

    @objc open var text: String? {
        didSet {
            updateStyle()
        }
    }

    open var source: NSObject?
    open var target: NSObject?

    @IBInspectable open var attributeKey: String?
    open var attributeType: FormFieldAttributeType = .text {
        didSet { updateAttributeType() }
    }
    @IBInspectable open var AttributeType: String {
        get { return attributeType.rawValue }
        set { attributeType = FormFieldAttributeType(rawValue: newValue) ?? .text }
    }
    open var attributeValue: NSObject? {
        didSet {
            updateAttributeValue()
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

    @IBInspectable open var isEditing: Bool = true

    @IBInspectable open var isEnabled: Bool = true {
        didSet {
            contentView.isUserInteractionEnabled = isEnabled
            updateStyle()
        }
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

        let statusButton = UIButton()
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.addTarget(self, action: #selector(statusPressed), for: .touchUpInside)
        borderedView.addSubview(statusButton)
        statusButtonWidthConstraint = statusButton.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            statusButton.topAnchor.constraint(equalTo: borderedView.topAnchor),
            statusButton.leftAnchor.constraint(equalTo: borderedView.leftAnchor),
            statusButton.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor),
            statusButtonWidthConstraint
        ])
        self.statusButton = statusButton

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        borderedView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: borderedView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: statusButton.rightAnchor),
            contentView.rightAnchor.constraint(equalTo: borderedView.rightAnchor),
            borderedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
        _errorLabel.textColor = .brandSecondary500
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
            borderedView.addOutline(size: 4, color: .brandPrimary200, opacity: 1)
        }
    }

    open func updateAttributeType() {

    }

    open func updateAttributeValue() {
        if let inputView = inputView as? FormInputView {
            text = inputView.text(for: attributeValue)
        } else {
            text = attributeValue as? String
        }
    }

    open func updateStyle() {
        if isPlainText {
            borderedView.backgroundColor = .clear
            borderedView.layer.borderWidth = 0
        } else {
            borderedView.backgroundColor = .white
            borderedView.layer.borderWidth = 2
            borderedView.layer.cornerRadius = 8
            if hasError {
                borderedView.layer.borderColor = UIColor.brandSecondary500.cgColor
                if isFirstResponder {
                    borderedView.addOutline(size: 4, color: .brandSecondary400, opacity: 1)
                } else {
                    borderedView.removeOutline()
                }
            } else if isFirstResponder {
                borderedView.layer.borderColor = UIColor.brandPrimary500.cgColor
                borderedView.addOutline(size: 4, color: .brandPrimary200, opacity: 1)
            } else {
                borderedView.layer.borderColor = isEnabled ?
                    (isEmpty ? UIColor.base500.cgColor : UIColor.brandPrimary300.cgColor) :
                    UIColor.base300.cgColor
                borderedView.removeOutline()
            }
        }

        label.font = .h4SemiBold
        label.textColor = hasError ? .brandSecondary500 : (isFirstResponder ? .brandPrimary500 : .base500)

        _errorLabel?.isHidden = !hasError

        statusButton.backgroundColor = .brandPrimary300
        if status != .none {
            if statusButton.image(for: .normal) == nil {
                statusButton.setImage(UIImage.image(withColor: .brandPrimary500, cornerRadius: 16,
                                                    iconImage: UIImage(named: "Voice24px", in: PRKitBundle.instance, compatibleWith: nil),
                                                    iconTintColor: .white),
                                      for: .normal)
            }
            statusButtonWidthConstraint.constant = 46
        } else {
            statusButton.setImage(nil, for: .normal)
            statusButtonWidthConstraint.constant = 0
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
        delegate?.formFieldDidChange?(self)
        if let inputView = inputView as? FormInputView, inputView.shouldResignAfterClear {
            resignFirstResponder()
        } else {
            reloadInputViews()
        }
    }

    @objc open func statusPressed() {
        delegate?.formFieldDidPressStatus?(self)
    }

    // MARK: - FormInputViewDelegate

    public func formInputView(_ inputView: FormInputView, didChange value: NSObject?) {
        attributeValue = value
        delegate?.formFieldDidChange?(self)
    }

    public func formInputView(_ inputView: FormInputView, wantsToPresent vc: UIViewController) {
        delegate?.formField?(self, wantsToPresent: vc)
    }
}
