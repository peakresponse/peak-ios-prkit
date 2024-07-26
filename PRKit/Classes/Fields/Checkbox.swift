//
//  Checkbox.swift
//  PRKit
//
//  Created by Francis Li on 10/21/21.
//

import UIKit

@objc public protocol CheckboxDelegate {
    @objc optional func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool)
}

@IBDesignable
open class Checkbox: UIView {
    open weak var button: UIButton!
    open weak var label: UILabel!

    @IBOutlet open weak var delegate: CheckboxDelegate?

    @IBInspectable open var isChecked: Bool {
        get { return button.isSelected }
        set { button.isSelected = newValue }
    }

    @IBInspectable open var l10nKey: String? {
        didSet { labelText = l10nKey?.localized }
    }

    @IBInspectable open var labelText: String? {
        get { return label.text }
        set {
            if let newValue = newValue {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                label.attributedText = NSAttributedString(string: newValue, attributes: [.paragraphStyle: paragraphStyle])
            } else {
                label.text = nil
            }
        }
    }

    @IBInspectable open var isRadioButton: Bool = false {
        didSet { setImages() }
    }
    open var isRadioButtonDeselectable = false
    open var cornerRadius: CGFloat { return isRadioButton ? 19 : 8 }
    open var innerCornerRadius: CGFloat { return isRadioButton ? 12 : 4 }

    @IBInspectable open var attributeKey: String?
    open var value: NSObject?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    @IBInspectable open var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
            updateUserInteractionState()
        }
    }

    open func commonInit() {
        backgroundColor = .clear

        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .top
        addSubview(row)
        NSLayoutConstraint.activate([
            row.leftAnchor.constraint(equalTo: leftAnchor),
            row.topAnchor.constraint(equalTo: topAnchor),
            row.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(equalTo: row.bottomAnchor)
        ])

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        row.addArrangedSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.button = button

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        row.addArrangedSubview(view)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.numberOfLines = 0
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
        self.label = label

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        tapRecognizer.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapRecognizer)
        label.isUserInteractionEnabled = true

        setImages()
        updateUserInteractionState()
    }

    open func setImages() {
        button.setBackgroundImage(UIImage.resizableImage(withColor: .textBackground, cornerRadius: cornerRadius, borderColor: .emptyBorder, borderWidth: 2), for: .normal)
        let disabledBg = UIImage.resizableImage(withColor: .textBackground, cornerRadius: cornerRadius, borderColor: .disabledBorder, borderWidth: 2)
        button.setBackgroundImage(disabledBg, for: .disabled)
        button.setBackgroundImage(disabledBg, for: [.disabled, .selected])
        let activeBg = UIImage.resizableImage(withColor: .textBackground, cornerRadius: cornerRadius, borderColor: .focusedBorder, borderWidth: 2)
        button.setBackgroundImage(activeBg, for: .focused)
        button.setBackgroundImage(activeBg, for: .highlighted)
        button.setBackgroundImage(activeBg, for: [.highlighted, .selected])
        button.setBackgroundImage(UIImage.resizableImage(withColor: .textBackground, cornerRadius: cornerRadius, borderColor: .border, borderWidth: 2), for: [.normal, .selected])
        let selected = UIImage.resizableImage(withColor: .focusedBorder, cornerRadius: innerCornerRadius).resizedTo(CGSize(width: 26, height: 26))
        button.setImage(selected, for: .selected)
        button.setImage(selected, for: [.highlighted, .selected])
        button.setImage(UIImage.resizableImage(withColor: .disabledBorder, cornerRadius: innerCornerRadius).resizedTo(CGSize(width: 26, height: 26)), for: [.disabled, .selected])
    }

    public static func sizeThatFits(_ width: CGFloat, with labelText: String) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        var labelSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        labelSize.width -= 48
        labelSize = (labelText as NSString).boundingRect(with: labelSize,
                                                         options: [.usesLineFragmentOrigin],
                                                         attributes: [
                                                            .font: UIFont.h4SemiBold,
                                                            .paragraphStyle: paragraphStyle
                                                         ], context: nil).size
        labelSize.width = width
        labelSize.height = max(40, round(labelSize.height) + 8)
        return labelSize
    }

    func updateUserInteractionState() {
        button.isEnabled = isEnabled
        label.textColor = isEnabled ? .labelText : .disabledLabelText
    }

    @objc func buttonPressed() {
        guard !button.isSelected || !isRadioButton || isRadioButtonDeselectable else { return }
        button.isSelected = !button.isSelected
        delegate?.checkbox?(self, didChange: button.isSelected)
    }
}
