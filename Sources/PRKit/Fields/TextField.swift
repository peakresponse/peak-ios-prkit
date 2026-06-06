//
//  TextField.swift
//  PRKit
//
//  Created by Francis Li on 9/4/20.
//

import UIKit

class TextFieldDropdownView: UIView, KeyboardSourceTableViewControllerDelegate {
    weak var textField: TextField!
    var stackView: UIStackView!
    var segmentedControl: SegmentedControl?
    var navVC: UINavigationController!

    init(textField: TextField) {
        self.textField = textField
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func commonInit() {
        backgroundColor = .clear
        addShadow(withOffset: .zero, radius: 4, color: .black, opacity: 0.25)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])

        guard case let .autocomplete(sources, isMultiSelect) = textField.attributeType, let sources, sources.count > 0 else { return }

        if sources.count > 1 {
            let segmentedControl = SegmentedControl()
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
            for source in sources {
                segmentedControl.addSegment(title: source.name)
            }
            stackView.addArrangedSubview(segmentedControl)
            self.segmentedControl = segmentedControl
        }

        let sourceVC = KeyboardSourceTableViewController()
        sourceVC.source = sources.first
        sourceVC.isMultiSelect = isMultiSelect
        sourceVC.delegate = self

        navVC = UINavigationController(rootViewController: sourceVC)
        navVC.isNavigationBarHidden = true
        navVC.view.backgroundColor = .white
        navVC.view.layer.borderColor = UIColor.focusedBorder.cgColor
        navVC.view.layer.borderWidth = 2
        navVC.view.layer.cornerRadius = 8
        navVC.view.clipsToBounds = true
        stackView.addArrangedSubview(navVC.view)
    }

    @objc func segmentedControlValueChanged(_ sender: SegmentedControl) {
        guard case let .autocomplete(sources, _) = textField.attributeType else { return }
        navVC.popToRootViewController(animated: false)
        if let sourceVC = navVC.viewControllers.first as? KeyboardSourceTableViewController,
           let source = sources?[sender.selectedIndex] {
            sourceVC.source = source
            sourceVC.tableView.reloadData()
        }
    }

    func reload() {
        navVC.popToRootViewController(animated: false)
        if let sourceVC = navVC.viewControllers.first as? KeyboardSourceTableViewController {
            sourceVC.tableView.reloadData()
        }
    }

    // MARK: - KeyboardSourceTableViewControllerDelegate

    @objc func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, isSelected value: NSObject) -> Bool {
        guard case let .autocomplete(_, isMultiSelect) = textField.attributeType else { return false }
        if isMultiSelect {
            let values = textField.attributeValue as? [NSObject] ?? []
            return values.contains(value)
        }
        return textField.attributeValue == value
    }

    @objc func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, didSelect value: NSObject) {
        guard case let .autocomplete(_, isMultiSelect) = textField.attributeType else { return }
        if isMultiSelect {
            if var values = textField.attributeValue as? [NSObject] {
                values.append(value)
                textField.attributeValue = values as NSObject
            } else {
                textField.attributeValue = [value] as NSObject
            }
        } else {
            textField.attributeValue = value
            textField.text = vc.source?.title(for: value)
        }
    }

    @objc func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, didDeselect value: NSObject) {
        guard case let .autocomplete(_, isMultiSelect) = textField.attributeType else { return }
        if isMultiSelect {
            if var values = textField.attributeValue as? [NSObject], let index = values.firstIndex(of: value) {
                values.remove(at: index)
                textField.attributeValue = values as NSObject
            } else {
                textField.attributeValue = [] as NSObject
            }
        } else {
            textField.attributeValue = nil
        }
    }
}

class InternalTextView: UITextView {
    weak var textField: TextField?
    var ignoreResignFirstResponder: Bool = false

    override func becomeFirstResponder() -> Bool {
        if !isEditable, let textField = textField {
            if !((textField.delegate as? FormFieldDelegate)?.formFieldShouldBeginEditing?(textField) ?? true) {
                return false
            }
        }
        if super.becomeFirstResponder() {
            selectedRange = NSRange(location: text.count, length: 0)
            textField?.updateStyle()
            textField?.reloadInputViews()
            if !isEditable, let textField = textField {
                (textField.delegate as? FormFieldDelegate)?.formFieldDidBeginEditing?(textField)
            }
            return true
        }
        return false
    }

    override func resignFirstResponder() -> Bool {
        if ignoreResignFirstResponder {
            return false
        }
        if super.resignFirstResponder() {
            (inputView as? FormInputView)?.removeAllSubInputViews()
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
        set { iconView.image = UIImage(named: "Search24px", in: PRKitBundle.instance, compatibleWith: nil)}
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
            updateStyle()
        }
    }
    @IBInspectable open var isMultiline: Bool = false
    @IBInspectable open var isDebounced: Bool = false
    @IBInspectable open var debounceTime: Double = 0.3
    open var debounceTimer: Timer?

    var dropdownView: TextFieldDropdownView?

    weak var _placeholderLabel: UILabel!
    open var placeholderLabel: UILabel {
        if _placeholderLabel == nil {
            initPlaceholderLabel()
        }
        return _placeholderLabel
    }

    weak var _unitLabel: UILabel!
    open var unitLabel: UILabel {
        if _unitLabel == nil {
            initUnitLabel()
        }
        return _unitLabel
    }
    open var unitLabelLeftConstraint: NSLayoutConstraint!
    @IBInspectable open var unitText: String? {
        didSet {
            unitLabel.text = unitText
        }
    }

    @IBInspectable open var placeholderText: String? {
        get { return _placeholderLabel?.text }
        set { placeholderLabel.text = newValue }
    }

    open override var inputView: UIView? {
        get { return textView.inputView }
        set { textView.inputView = newValue }
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
        textView.backgroundColor = .clear
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
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
            textViewHeightConstraint,
            contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 2)
        ])
        self.textView = textView
        self.textViewHeightConstraint = textViewHeightConstraint

        let clearButton = UIButton(type: .custom)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(named: "Exit24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        clearButton.imageView?.tintColor = .labelText
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearPressed(_:)), for: .touchUpInside)
        contentView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
        self.clearButton = clearButton
    }

    private func initPlaceholderLabel() {
        guard _placeholderLabel == nil else { return }
        let placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = textView.font
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.isHidden = !isEmpty
        contentView.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leftAnchor.constraint(equalTo: textView.leftAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: textView.rightAnchor)
        ])
        _placeholderLabel = placeholderLabel
    }

    private func initUnitLabel() {
        guard _unitLabel == nil else { return }
        let unitLabel = UILabel()
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = textView.font
        unitLabel.textColor = .base500
        unitLabel.isHidden = isEmpty && !isFirstResponder
        contentView.addSubview(unitLabel)
        unitLabelLeftConstraint = unitLabel.leftAnchor.constraint(equalTo: label.leftAnchor)
        unitLabelLeftConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            unitLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            unitLabelLeftConstraint,
            unitLabel.rightAnchor.constraint(lessThanOrEqualTo: textView.rightAnchor)
        ])
        _unitLabel = unitLabel
    }

    private func initIconView() {
        guard _iconView == nil else { return }
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .labelText
        iconView.contentMode = .center
        iconView.isHidden = !isEmpty
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: -1)
        ])
        _iconView = iconView
    }

    open override func clearPressed(_ sender: UIButton? = nil) {
        super.clearPressed(sender)
        if case .autocomplete(_, _) = attributeType {
            textViewDidChange(textView)
            if isFirstResponder {
                showDropdown()
            }
        }
    }
    open override func updateAttributeType() {
        (textView as? InternalTextView)?.ignoreResignFirstResponder = true
        let inputView = attributeType.inputView
        textView.isEditable = inputView?.isTextViewEditable ?? true
        (textView as? InternalTextView)?.ignoreResignFirstResponder = false
        self.inputView = inputView
        switch attributeType {
        case .text:
            autocorrectionType = .default
        default:
            autocorrectionType = .no
        }
        if attributeType == .autocomplete() && isFirstResponder {
            showDropdown()
        } else {
            if case let .autocomplete(sources, isMultiSelect) = attributeTypes[0] {
                if isMultiSelect || attributeValue == nil {
                    text = nil
                    for source in sources ?? [] {
                        source.search(nil, callback: nil)
                    }
                }
            }
            hideDropdown()
        }
    }

    open override func reloadInputViews() {
        attributeType.configureInputView(delegate: self, textView: textView)
        textView.reloadInputViews()
        super.reloadInputViews()
    }

    open override func didUpdateAttributeValue() {
        unitLabel.text = attributeType.unitText(for: attributeValue) ?? unitText
        unitLabelLeftConstraint?.constant = widthForText(text ?? "", font: textView.font!)
        super.didUpdateAttributeValue()
    }

    override open func updateStyle() {
        super.updateStyle()
        let isTextViewEmpty = textView.text?.isEmpty ?? true
        textView.textColor = .text
        textViewHeightConstraint.constant = heightForText(textView.text, font: textView.font!, width: textView.frame.width)
        unitLabelLeftConstraint?.constant = widthForText(textView.text, font: textView.font!)
        clearButton.isHidden = isTextViewEmpty || !isEnabled
        _iconView?.isHidden = !isTextViewEmpty
        _placeholderLabel?.isHidden = !isTextViewEmpty
        _unitLabel?.isHidden = isTextViewEmpty && !isFirstResponder
    }

    open override var canBecomeFirstResponder: Bool {
        return isEnabled && textView.canBecomeFirstResponder
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

    override open func didScrollIntoView(_ scrollView: UIScrollView) {
        if let dropdownView = dropdownView {
            scrollView.isScrollEnabled = false
            scrollView.addSubview(dropdownView)
            let height = round(scrollView.frame.height - scrollView.safeAreaInsets.top - 108)
            let constraints = [
                dropdownView.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 14),
                dropdownView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                dropdownView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                dropdownView.heightAnchor.constraint(equalToConstant: height),
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }

    func showDropdown() {
        if dropdownView == nil {
            let dropdownView = TextFieldDropdownView(textField: self)
            dropdownView.translatesAutoresizingMaskIntoConstraints = false
            self.dropdownView = dropdownView
        }
    }

    func hideDropdown() {
        var superview: UIView? = superview
        while !(superview is UIScrollView) && superview != nil {
            superview = superview?.superview
        }
        if let scrollView = superview as? UIScrollView {
            scrollView.isScrollEnabled = true
        }
        dropdownView?.removeFromSuperview()
        dropdownView = nil
    }

    // MARK: - NSTextStorageDelegate

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            let isTextViewEmpty = textView.text?.isEmpty ?? true
            _placeholderLabel?.isHidden = !isTextViewEmpty
            _iconView?.isHidden = !isTextViewEmpty
            clearButton.isHidden = isTextViewEmpty || !isEnabled
        }
    }

    // MARK: - UITextViewDelegate

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return (delegate as? FormFieldDelegate)?.formFieldShouldBeginEditing?(self) ?? true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        (delegate as? FormFieldDelegate)?.formFieldDidBeginEditing?(self)
        if case .autocomplete(_, _) = attributeType {
            showDropdown()
        }
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return (delegate as? FormFieldDelegate)?.formFieldShouldEndEditing?(self) ?? true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if case let .autocomplete(sources, isMultiSelect) = attributeType {
            if isMultiSelect || attributeValue == nil {
                text = nil
            }
            for source in sources ?? [] {
                source.search(nil, callback: nil)
            }
            hideDropdown()
        }
        (delegate as? FormFieldDelegate)?.formFieldDidEndEditing?(self)
    }

    public func textViewDidChange(_ textView: UITextView) {
        if case let .autocomplete(sources, _) = attributeType {
            var text: String?
            if !(textView.text?.isEmpty ?? true) {
                text = textView.text
            }
            for source in sources ?? [] {
                source.search(text, callback: nil)
            }
            dropdownView?.reload()
            return
        }
        text = textView.text ?? ""
        attributeValue = text as NSObject?
        if isDebounced {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTime, repeats: false, block: { [weak self] (_) in
                guard let self = self else { return }
                self.delegate?.formComponentDidChange?(self)
            })
        } else {
            delegate?.formComponentDidChange?(self)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if case let .autocomplete(_, isMultiSelect) = attributeType {
            if  (!isMultiSelect && !attributeValues.reduce(true, { $0 && $1 == nil })) ||
                (isMultiSelect && attributeValue == nil && !attributeValues.reduce(true, { $0 && $1 == nil })) {
                attributeValues = .init(repeating: nil, count: attributeTypes.count)
                if text == "" {
                    textViewDidChange(textView)
                }
                showDropdown()
            }
            return true
        }
        if text == "\n" || text == "\t" {
            if !((delegate as? FormFieldDelegate)?.formFieldShouldReturn?(self) ?? true) {
                return false
            } else if isMultiline {
                return true
            }
            _ = resignFirstResponder()
            return false
        }
        var currentValue: String?
        if let values = attributeValues[attributeIndex] as? [NSObject] {
            currentValue = values[0] as? String
        } else {
            currentValue = attributeValues[attributeIndex] as? String
        }
        if textView.text != currentValue {
            textView.text = ""
        }
        return true
    }
}
