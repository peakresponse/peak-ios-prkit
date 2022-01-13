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

    open weak var delegate: CheckboxDelegate?

    @IBInspectable open var isChecked: Bool {
        get { return button.isSelected }
        set { button.isSelected = newValue }
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
    open var cornerRadius: CGFloat { return isRadioButton ? 19 : 8 }
    open var innerCornerRadius: CGFloat { return isRadioButton ? 12 : 4 }

    open var value: NSObject?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override open var isUserInteractionEnabled: Bool {
        get { return super.isUserInteractionEnabled }
        set {
            super.isUserInteractionEnabled = newValue
            updateUserInteractionState()
        }
    }

    open func commonInit() {
        backgroundColor = .clear

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),
            bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor)
        ])
        self.button = button

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.numberOfLines = 0
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor)
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
        button.setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: cornerRadius, borderColor: .base500, borderWidth: 2), for: .normal)
        let disabledBg = UIImage.resizableImage(withColor: .white, cornerRadius: cornerRadius, borderColor: .base300, borderWidth: 2)
        button.setBackgroundImage(disabledBg, for: .disabled)
        button.setBackgroundImage(disabledBg, for: [.disabled, .selected])
        let activeBg = UIImage.resizableImage(withColor: .white, cornerRadius: cornerRadius, borderColor: .brandPrimary500, borderWidth: 2)
        button.setBackgroundImage(activeBg, for: .focused)
        button.setBackgroundImage(activeBg, for: .highlighted)
        button.setBackgroundImage(activeBg, for: [.highlighted, .selected])
        button.setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: cornerRadius, borderColor: .brandPrimary300, borderWidth: 2), for: [.normal, .selected])
        let selected = UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: innerCornerRadius).resizedTo(CGSize(width: 26, height: 26))
        button.setImage(selected, for: .selected)
        button.setImage(selected, for: [.highlighted, .selected])
        button.setImage(UIImage.resizableImage(withColor: .base500, cornerRadius: innerCornerRadius).resizedTo(CGSize(width: 26, height: 26)), for: [.disabled, .selected])
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
        button.isEnabled = isUserInteractionEnabled
        label.textColor = isUserInteractionEnabled ? .base800 : .base300
    }

    @objc func buttonPressed() {
        guard !isRadioButton || !button.isSelected else { return }
        button.isSelected = !button.isSelected
        delegate?.checkbox?(self, didChange: button.isSelected)
    }
}
