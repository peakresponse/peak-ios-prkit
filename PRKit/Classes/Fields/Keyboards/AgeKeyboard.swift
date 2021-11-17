//
//  AgeKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/16/21.
//

import UIKit

open class AgeKeyboard: NumberKeypad, UIPickerViewDataSource, UIPickerViewDelegate {
    open weak var ageUnitPicker: UIPickerView!
    open var ageUnitSource: PickerKeyboardSource?

    open override func commonInit() {
        super.commonInit()

        let ageUnitPicker = UIPickerView()
        ageUnitPicker.translatesAutoresizingMaskIntoConstraints = false
        ageUnitPicker.dataSource = self
        ageUnitPicker.delegate = self
        ageUnitPicker.isHidden = true
        addSubview(ageUnitPicker)
        NSLayoutConstraint.activate([
            ageUnitPicker.topAnchor.constraint(equalTo: topAnchor),
            ageUnitPicker.leftAnchor.constraint(equalTo: leftAnchor),
            ageUnitPicker.rightAnchor.constraint(equalTo: rightAnchor),
            ageUnitPicker.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        self.ageUnitPicker = ageUnitPicker
    }

    public override func setValue(_ value: AnyObject?) {
        if let source = ageUnitSource, let value = value as? [String], value.count == 2, let index = source.values.firstIndex(of: value[1]) {
            self.value = value[0]
            ageUnitPicker.selectRow(index, inComponent: 0, animated: false)
        } else {
            self.value = ""
            ageUnitPicker.selectRow(0, inComponent: 0, animated: false)
            decimalButton.setTitle(ageUnitSource?.pickerView?(ageUnitPicker, titleForRow: 0, forComponent: 0), for: .normal)
            pickerView(ageUnitPicker, didSelectRow: 0, inComponent: 0)
        }
        textView.selectedRange = NSRange(location: self.value.count, length: 0)
    }

    override func buttonPressed(_ button: Button) {
        if button.tag == 10 {
            ageUnitPicker.isHidden = !ageUnitPicker.isHidden
            let title = ageUnitPicker.isHidden ? ageUnitSource?.pickerView?(ageUnitPicker, titleForRow: 0, forComponent: 0) : "123"
            decimalButton.setTitle(title, for: .normal)
            if ageUnitPicker.isHidden {
                decimalButton.removeFromSuperview()
                let row = rows.arrangedSubviews[3] as! UIStackView
                row.insertArrangedSubview(decimalButton, at: 0)
                rows.isHidden = false
            } else {
                rows.isHidden = true
                decimalButton.removeFromSuperview()
                addSubview(decimalButton)
                NSLayoutConstraint.activate([
                    decimalButton.topAnchor.constraint(equalTo: buttons[10].topAnchor),
                    decimalButton.rightAnchor.constraint(equalTo: buttons[0].rightAnchor),
                    decimalButton.bottomAnchor.constraint(equalTo: buttons[10].bottomAnchor),
                    decimalButton.leftAnchor.constraint(equalTo: buttons[0].leftAnchor)
                ])
            }
        } else {
            if textView.selectedRange.location > value.count {
                textView.selectedRange = NSRange(location: value.count, length: 0)
            }
            super.buttonPressed(button)
            if let unitValue = ageUnitSource?.value(for: ageUnitPicker.selectedRow(inComponent: 0)) {
                delegate?.formFieldInputView(self, didChange: [value, unitValue] as AnyObject)
            }
            if textView.selectedRange.location > value.count {
                textView.selectedRange = NSRange(location: value.count, length: 0)
            }
        }
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ageUnitSource?.numberOfComponents(in: pickerView) ?? 0
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageUnitSource?.pickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageUnitSource?.pickerView?(pickerView, titleForRow: row, forComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let unitValue = ageUnitSource?.value(for: row) {
            delegate?.formFieldInputView(self, didChange: [value, unitValue] as AnyObject)
        }
    }
}
