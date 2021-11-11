//
//  PickerKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

public protocol PickerKeyboardSourceEnum: CaseIterable, CustomStringConvertible {
    var rawValue: String { get }
}

public protocol PickerKeyboardSource: UIPickerViewDelegate, UIPickerViewDataSource {
    var values: [String] { get }
    func title(for value: String?) -> String?
    func value(for row: Int) -> String?
}

open class PickerKeyboardSourceWrapper<T: PickerKeyboardSourceEnum>: NSObject, PickerKeyboardSource {
    public var values: [String] {
        return T.allCases.map { $0.rawValue }
    }

    public func title(for value: String?) -> String? {
        if let value = value {
            return T.allCases.first(where: {$0.rawValue == value})?.description
        }
        return nil
    }

    public func value(for row: Int) -> String? {
        return T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: row)].rawValue
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return T.allCases.count
    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: row)])
    }
}

open class PickerKeyboard: UIView, FormFieldInputView, UIPickerViewDelegate, UIPickerViewDataSource {
    open weak var picker: UIPickerView!
    open weak var delegate: FormFieldInputViewDelegate?
    open var source: PickerKeyboardSource?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: topAnchor),
            picker.leftAnchor.constraint(equalTo: leftAnchor),
            picker.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: picker.bottomAnchor)
        ])
        self.picker = picker
    }

    public func setValue(_ value: AnyObject?) {
        if let source = source, let value = value as? String, let index = source.values.firstIndex(of: value) {
            picker.selectRow(index, inComponent: 0, animated: false)
        } else {
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return source?.numberOfComponents(in: pickerView) ?? 0
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source?.pickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return source?.pickerView?(pickerView, titleForRow: row, forComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = source?.value(for: row)
        delegate?.formFieldInputView(self, didChange: value as AnyObject)
    }
}
