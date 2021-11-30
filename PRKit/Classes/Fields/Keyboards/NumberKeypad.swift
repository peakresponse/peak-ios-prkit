//
//  NumberKeypad.swift
//  PRKit
//
//  Created by Francis Li on 11/16/21.
//

import UIKit

open class NumberKeypad: FormInputView {
    open weak var rows: UIStackView!
    open var buttons: [Button] = []

    open var decimalButton: Button {
        get { return buttons[9] }
    }
    open var isDecimalHidden: Bool {
        get { return decimalButton.alpha == 0 }
        set { decimalButton.alpha = newValue ? 0 : 1 }
    }

    open var value: String = ""

    open override var isTextViewEditable: Bool {
        return true
    }

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let spacing: CGFloat = 6
        let rows = UIStackView()
        rows.translatesAutoresizingMaskIntoConstraints = false
        rows.axis = .vertical
        rows.distribution = .fillEqually
        rows.spacing = spacing
        addSubview(rows)
        let rowWidth = rows.widthAnchor.constraint(equalToConstant: 690)
        rowWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            rows.topAnchor.constraint(equalTo: topAnchor),
            rows.centerXAnchor.constraint(equalTo: centerXAnchor),
            rowWidth,
            rows.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: spacing),
            rows.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -spacing),
            safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: rows.bottomAnchor, constant: spacing)
        ])
        self.rows = rows

        var row: UIStackView!
        for i in 1..<13 {
            if i % 3 == 1 {
                row = UIStackView()
                row.axis = .horizontal
                row.distribution = .fillEqually
                row.spacing = spacing
                rows.addArrangedSubview(row)
            }
            let button = Button()
            button.translatesAutoresizingMaskIntoConstraints = false
            var title: String?
            if i < 10 {
                title = "\(i)"
            } else if i == 10 {
                title = "."
            } else if i == 11 {
                title = "0"
            } else if i == 12 {
                title = nil
                button.setImage(UIImage(named: "Delete40px", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            }
            button.setTitle(title, for: .normal)
            button.size = .medium
            button.style = .secondary
            button.tag = i
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            row.addArrangedSubview(button)
            buttons.append(button)
        }
    }

    open override func setValue(_ value: AnyObject?) {
        if let value = value {
            self.value = "\(value)"
            decimalButton.isEnabled = !self.value.contains(".")
        } else {
            self.value = ""
        }
    }

    @objc func buttonPressed(_ button: Button) {
        var range = textView.selectedRange
        if button.tag == 12 {
            if value.count == 0 || (range.location == 0 && range.length == 0) {
                return
            }
            if range.length == 0 {
                range = NSRange(location: range.location - 1, length: 1)
            }
            if textView.delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: "") ?? true {
                value = (value as NSString).replacingCharacters(in: range, with: "")
            }
            range = NSRange(location: range.location, length: 0)
        } else {
            var replacementText: String!
            if button.tag < 10 {
                if value == "0" {
                    range = NSRange(location: 0, length: 1)
                }
                replacementText = "\(button.tag)"
            } else if button.tag == 10 {
                if value == "" {
                    replacementText = "0."
                } else {
                    replacementText = "."
                }
            } else if button.tag == 11 {
                if value == "0" {
                    return
                }
                if value.count > 0, range.location == 0 {
                    return
                }
                replacementText = "0"
            }
            if textView.delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: replacementText) ?? true {
                value = (value as NSString).replacingCharacters(in: range, with: replacementText)
            }
            range = NSRange(location: range.location + replacementText.count, length: 0)
        }
        decimalButton.isEnabled = !self.value.contains(".")
        delegate?.formInputView(self, didChange: value as AnyObject)
        textView.selectedRange = range
    }
}
