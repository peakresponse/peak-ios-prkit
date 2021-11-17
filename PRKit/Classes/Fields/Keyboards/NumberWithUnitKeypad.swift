//
//  NumberWithUnitKeypad.swift
//  PRKit
//
//  Created by Francis Li on 11/16/21.
//

import UIKit

open class NumberWithUnitKeypad: NumberKeypad, UIPickerViewDataSource, UIPickerViewDelegate {
    open weak var unitPicker: UIPickerView!
    open var unitSource: PickerKeyboardSource?

    open override func commonInit() {
        super.commonInit()

        let unitPicker = UIPickerView()
        unitPicker.translatesAutoresizingMaskIntoConstraints = false
        unitPicker.dataSource = self
        unitPicker.delegate = self
        unitPicker.isHidden = true
        addSubview(unitPicker)
        NSLayoutConstraint.activate([
            unitPicker.topAnchor.constraint(equalTo: topAnchor),
            unitPicker.leftAnchor.constraint(equalTo: leftAnchor),
            unitPicker.rightAnchor.constraint(equalTo: rightAnchor),
            unitPicker.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        self.unitPicker = unitPicker
    }

    public override func setValue(_ value: AnyObject?) {
        if let source = unitSource, let value = value as? [String], value.count == 2, let index = source.values.firstIndex(of: value[1]) {
            self.value = value[0]
            unitPicker.selectRow(index, inComponent: 0, animated: false)
        } else {
            self.value = ""
            unitPicker.selectRow(0, inComponent: 0, animated: false)
            decimalButton.setTitle(unitSource?.pickerView?(unitPicker, titleForRow: 0, forComponent: 0), for: .normal)
            pickerView(unitPicker, didSelectRow: 0, inComponent: 0)
        }
        textView.selectedRange = NSRange(location: self.value.count, length: 0)
    }

    override func buttonPressed(_ button: Button) {
        if button.tag == 10 {
            unitPicker.isHidden = !unitPicker.isHidden
            let title = unitPicker.isHidden ? unitSource?.pickerView?(unitPicker, titleForRow: 0, forComponent: 0) : "123"
            decimalButton.setTitle(title, for: .normal)
            if unitPicker.isHidden {
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
            if let unitValue = unitSource?.value(for: unitPicker.selectedRow(inComponent: 0)) {
                delegate?.formFieldInputView(self, didChange: [value, unitValue] as AnyObject)
            }
            if textView.selectedRange.location > value.count {
                textView.selectedRange = NSRange(location: value.count, length: 0)
            }
        }
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return unitSource?.numberOfComponents(in: pickerView) ?? 0
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitSource?.pickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitSource?.pickerView?(pickerView, titleForRow: row, forComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let unitValue = unitSource?.value(for: row) {
            delegate?.formFieldInputView(self, didChange: [value, unitValue] as AnyObject)
        }
    }
}
