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
    case single(KeyboardSource? = nil)
    case multi(KeyboardSource? = nil)
    case custom(FormInputView? = nil)
    case autocomplete([KeyboardSource]? = nil)

    var rawValue: String {
        return String(describing: self)
    }

    var buttonLabel: String {
        switch self {
        case .integer, .integerWithUnit(_), .decimal, .decimalWithUnit(_):
            return "Button.123".localized
        case .date, .datetime:
            return "Button.date".localized
        case .single(let source), .multi(let source):
            return source?.name ?? ""
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
        case "single":
            self = .single()
        case "multi":
            self = .multi()
        case "custom":
            self = .custom()
        case "autocomplete":
            self = .autocomplete()
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
            if let value = value as? Date {
                return value.asDateTimeString()
            } else if let value = value as? String, let value = try? Date(value, strategy: .iso8601) {
                return value.asDateTimeString()
            }
            return nil
        case .integerWithUnit(_), .decimalWithUnit(_):
            if let value = value as? [String?], value.count > 0 {
                return value[0]
            }
            return nil
        case .single(let source), .multi(let source):
            if let value = value as? [NSObject] {
                return value.compactMap({ text(for: $0) }).joined(separator: "\n")
            }
            return source?.title(for: value)
        case .custom(let inputView):
            return inputView?.text(for: value)
        case .autocomplete(let sources):
            for source in sources ?? [] {
                if let text = source.title(for: value) {
                    return text
                }
            }
            return nil
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
        case (.single, .single):
            return true
        case (.multi, .multi):
            return true
        case (.custom, .custom):
            return true
        case (.autocomplete, .autocomplete):
            return true
        default:
            return false
        }
    }
}

class FormFieldValue: UIView {
    var stackView: UIStackView!
    var separatorView: UIView!
    var label: UILabel!
    var clearButton: UIButton!

    var labelText: String? {
        get { label.text }
        set {
            if let newValue {
                let attributedText = NSMutableAttributedString(string: newValue)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 0.2 * label.font.lineHeight
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: attributedText.length))
                label.attributedText = attributedText
            } else {
                label.text = nil
            }
        }
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let view = UIView()
        stackView.addArrangedSubview(view)

        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.numberOfLines = 0
        label.textColor = .text
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6 - 0.2 * label.font.lineHeight)
        ])

        clearButton = UIButton(type: .custom)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(named: "Exit24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        clearButton.imageView?.tintColor = .labelText
        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 12),
            clearButton.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor)
        ])

        separatorView = UIView()
        stackView.addArrangedSubview(separatorView)

        let hr = UIView()
        hr.translatesAutoresizingMaskIntoConstraints = false
        hr.backgroundColor = .disabledBorder
        separatorView.addSubview(hr)
        NSLayoutConstraint.activate([
            hr.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: 0),
            hr.heightAnchor.constraint(equalToConstant: 2),
            hr.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -4),
            hr.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            hr.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor)
        ])
    }
}

open class FormField: FormComponent, Localizable, FormInputViewDelegate {
    open weak var borderedView: UIView!
    open weak var stackView: UIStackView!
    open weak var contentStackView: UIStackView!
    open weak var contentView: UIView!
    var multiValueViews: [FormFieldValue]?

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

    open override var attributeIndex: Int {
        didSet {
            updateAttributeType()
        }
    }
    open var attributeSeparator = " - "
    open var attributeTypes: [FormFieldAttributeType] = [.text] {
        didSet {
            attributeValues = [.init(repeating: nil, count: attributeTypes.count)]
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

    private var _inputAccessoryView: UIView?
    open override var inputAccessoryView: UIView? {
        get { return _inputAccessoryView }
        set { _inputAccessoryView = newValue }
    }

    open var inputAccessoryViewOtherButtonTitle: String?

    open var isEmpty: Bool {
        var isEmpty = true
        for row in attributeValues {
            isEmpty = isEmpty && row.reduce(into: true) { (partialResult, value) in
                partialResult = partialResult && ((value as? String)?.isEmpty ?? (value == NSNull()))
            }
            if !isEmpty {
                break
            }
        }
        return isEmpty
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
        contentStackView.spacing = 0
        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
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
        if isMultiValue {
            // for now, brute force remove all...
            if let multiValueViews {
                for view in multiValueViews {
                    view.removeFromSuperview()
                }
                self.multiValueViews?.removeAll()
            }
            // then re-add
            for (i, row) in attributeValues.enumerated() {
                let text = row.enumerated().compactMap({ attributeTypes[$0].text(for: $1)}).joined(separator: attributeSeparator)
                if i == attributeValues.count - 1 {
                    self.text = text
                    if attributeValues.count == 1 {
                        contentView.isHidden = false
                    }
                } else {
                    if multiValueViews == nil {
                        multiValueViews = []
                    }
                    let valueView = FormFieldValue()
                    multiValueViews?.append(valueView)
                    contentStackView.insertArrangedSubview(valueView, at: contentStackView.arrangedSubviews.count - 1)
                    valueView.labelText = text
                    valueView.clearButton.addTarget(self, action: #selector(clearPressed(_:)), for: .touchUpInside)
                }
            }
            if contentView.isHidden {
                multiValueViews?.last?.separatorView.isHidden = true
            }
            if isFirstResponder {
                DispatchQueue.main.async {
                    self.scrollIntoView()
                }
            }
        } else {
            self.text = attributeValues[0].enumerated().compactMap { attributeTypes[$0].text(for: $1) }.joined(separator: attributeSeparator)
        }
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
        if let inputAccessoryView = inputAccessoryView as? FormInputAccessoryView, isFirstResponder {
            inputAccessoryView.currentView = self
        }
    }

    @objc open func clearPressed(_ sender: UIButton? = nil) {
        var found = false
        if let sender, let multiValueViews {
            for (i, view) in multiValueViews.enumerated() where sender.isDescendant(of: view) {
                found = true
                attributeRow -= 1
                attributeValues.remove(at: i)
                break
            }
        }
        if !found {
            attributeValues = [.init(repeating: nil, count: attributeTypes.count)]
        }
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

    open func scrollIntoView() {
        var superview: UIView? = superview
        while !(superview is UIScrollView) && superview != nil {
            superview = superview?.superview
        }
        if let scrollView = superview as? UIScrollView, let superview = self.superview {
            let rect = superview.convert(frame, to: scrollView)
            UIView.animate(withDuration: 0.25, animations: {
                scrollView.contentOffset = CGPoint(x: 0,
                                                   y: rect.origin.y + rect.height - scrollView.safeAreaInsets.top - 95)
            }) { _ in
                self.didScrollIntoView(scrollView)
            }
        }

    }

    // MARK: - FormInputViewDelegate

    open func formInputView(_ inputView: FormInputView, didChange value: NSObject?) {
        attributeValue = value
        delegate?.formComponentDidChange?(self)
    }

    open func formInputView(_ inputView: FormInputView, wantsToPresent vc: UIViewController) {
        (delegate as? FormFieldDelegate)?.formField?(self, wantsToPresent: vc)
    }

    // MARK: - UIResponder

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1, let touch = touches.first, bounds.contains(touch.location(in: self)), canBecomeFirstResponder {
            _ = becomeFirstResponder()
            return
        }
        super.touchesBegan(touches, with: event)
    }
}
