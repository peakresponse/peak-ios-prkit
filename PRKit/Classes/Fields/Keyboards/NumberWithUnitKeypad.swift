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

    open override var shouldResignAfterClear: Bool {
        return true
    }

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

    override func buttonPressed(_ button: Button) {
        super.buttonPressed(button)
        if let unitValue = unitSource?.value(for: unitPicker.selectedRow(inComponent: 0)) {
            delegate?.formInputView(self, didChange: [value, unitValue] as AnyObject)
        }
    }

    public override func setValue(_ value: AnyObject?) {
        if let source = unitSource, let value = value as? [String], value.count == 2, let index = source.values.firstIndex(of: value[1]) {
            self.value = value[0]
            unitPicker.selectRow(index, inComponent: 0, animated: false)
        } else {
            self.value = ""
            unitPicker.selectRow(0, inComponent: 0, animated: false)
            pickerView(unitPicker, didSelectRow: 0, inComponent: 0)
        }
        textView.selectedRange = NSRange(location: self.value.count, length: 0)
        unitPicker.isHidden = true
        rows.isHidden = false
    }

    open override func text(for value: AnyObject?) -> String? {
        if let value = value as? [String], value.count == 2 {
            return value[0]
        }
        return nil
    }

    open override func unitText(for value: AnyObject?) -> String? {
        if let value = value as? [String], value.count == 2, let unit = unitSource?.title(for: value[1]) {
            return " \(unit)"
        }
        return nil
    }

    open override var accessoryOtherButtonTitle: String? {
        return unitSource?.pickerView?(unitPicker, titleForRow: unitPicker.selectedRow(inComponent: 0), forComponent: 0)
    }

    open override func accessoryOtherButtonPressed(_ inputAccessoryView: FormInputAccessoryView) -> String? {
        unitPicker.isHidden = !unitPicker.isHidden
        rows.isHidden = !unitPicker.isHidden
        return unitPicker.isHidden ? accessoryOtherButtonTitle : "123"
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
            delegate?.formInputView(self, didChange: [value, unitValue] as AnyObject)
        }
    }
}
