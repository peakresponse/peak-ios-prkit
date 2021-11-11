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
    @objc optional func formFieldDidConfirmStatus(_ field: FormField)
    @objc optional func formField(_ field: FormField, needsSourceFor pickerKeyboard: PickerKeyboard) -> AnyObject?
}

public enum FormFieldAttributeType: String {
    case text, integer, decimal, datetime, age, gender, picker
}

open class FormField: UIView, Localizable {
    open weak var contentView: UIView!

    open var status: PredictionStatus = .none {
        didSet { updateStyle() }
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

    @objc open var text: String?

    open weak var source: AnyObject?
    open weak var target: AnyObject?

    @IBInspectable open var attributeKey: String?
    open var attributeType: FormFieldAttributeType = .text {
        didSet { updateAttributeType() }
    }
    @IBInspectable open var AttributeType: String {
        get { return attributeType.rawValue }
        set { attributeType = FormFieldAttributeType(rawValue: newValue) ?? .text }
    }
    open var attributeValue: AnyObject? {
        didSet { updateAttributeValue() }
    }

    open override var isUserInteractionEnabled: Bool {
        didSet { updateStyle() }
    }

    @IBInspectable open var isPlainText: Bool = false {
        didSet { updateStyle() }
    }

    @IBInspectable open var isEditing: Bool = true

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

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.contentView = contentView

        let statusButton = UIButton()
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.addTarget(self, action: #selector(statusPressed), for: .touchUpInside)
        contentView.addSubview(statusButton)
        statusButtonWidthConstraint = statusButton.widthAnchor.constraint(equalToConstant: 8)
        NSLayoutConstraint.activate([
            statusButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            statusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statusButtonWidthConstraint
        ])
        self.statusButton = statusButton

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 28)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: statusButton.rightAnchor, constant: 16),
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
            _errorLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            _errorLabel.heightAnchor.constraint(equalToConstant: 18),
            _errorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            _errorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            bottomConstraint
        ])
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if isFirstResponder {
            contentView.addOutline(size: 4, color: .brandPrimary200, opacity: 1)
        }
    }

    open func updateAttributeType() {

    }

    open func updateAttributeValue() {

    }

    open func updateStyle() {
        if isPlainText {
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderWidth = 2
            contentView.layer.cornerRadius = 8
            if hasError {
                contentView.layer.borderColor = UIColor.brandSecondary500.cgColor
                if isFirstResponder {
                    contentView.addOutline(size: 4, color: .brandSecondary400, opacity: 1)
                } else {
                    contentView.removeOutline()
                }
            } else if isFirstResponder {
                contentView.layer.borderColor = UIColor.brandPrimary500.cgColor
                contentView.addOutline(size: 4, color: .brandPrimary200, opacity: 1)
            } else {
                contentView.layer.borderColor = isUserInteractionEnabled ?
                    (text?.isEmpty ?? true ? UIColor.base500.cgColor : UIColor.brandPrimary300.cgColor) :
                    UIColor.base300.cgColor
                contentView.removeOutline()
            }
        }

        label.font = .h4SemiBold
        label.textColor = hasError ? .brandSecondary500 : (isFirstResponder ? .brandPrimary500 : .base500)

        statusButton.backgroundColor = .middlePeakBlue
        statusButton.backgroundColor = status == .unconfirmed ? UIColor.orangeAccent.withAlphaComponent(0.3) : UIColor.middlePeakBlue
        statusButton.isUserInteractionEnabled = isEditing && status == .unconfirmed
        statusButton.setImage(isEditing && status == .unconfirmed ? UIImage(named: "Unconfirmed") : nil, for: .normal)

        _errorLabel?.isHidden = !hasError

        if status == .none || text?.isEmpty ?? true {
            statusButtonWidthConstraint.constant = 0
        } else if isEditing && status == .unconfirmed {
            statusButtonWidthConstraint.constant = 33
        } else {
            statusButtonWidthConstraint.constant = 8
        }
    }

    @objc open func clearPressed() {
        text = nil
        updateStyle()
        delegate?.formFieldDidChange?(self)
    }

    @objc open func statusPressed() {
        status = .confirmed
        updateStyle()
        delegate?.formFieldDidConfirmStatus?(self)
    }
}
