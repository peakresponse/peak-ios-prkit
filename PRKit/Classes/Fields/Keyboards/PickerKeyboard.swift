//
//  PickerKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

@objc public protocol PickerKeyboardDelegate {
    @objc optional func pickerKeyboard(_ keyboard: PickerKeyboard, didSelect rawValue: String, description: String)
    @objc optional func pickerKeyboardNeedsSource(_ keyboard: PickerKeyboard) -> AnyObject?
}

public protocol RawStringRepresentable {
    var rawValue: String { get }
}

open class PickerKeyboardSource<T: CaseIterable & RawStringRepresentable>: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    open weak var pickerKeyboard: PickerKeyboard?

    public init(pickerKeyboard: PickerKeyboard) {
        self.pickerKeyboard = pickerKeyboard
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

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerKeyboard = pickerKeyboard else { return }
        let value = T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: row)]
        let description = String(describing: value)
        pickerKeyboard.delegate?.pickerKeyboard?(pickerKeyboard, didSelect: value.rawValue, description: description)
    }
}

open class PickerKeyboard: UIView {
    open weak var picker: UIPickerView!
    open weak var delegate: PickerKeyboardDelegate?

    var source: AnyObject?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picker)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: topAnchor),
            picker.leftAnchor.constraint(equalTo: leftAnchor),
            picker.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: picker.bottomAnchor)
        ])
        self.picker = picker
    }

    open override func reloadInputViews() {
        if picker.dataSource == nil || picker.delegate == nil {
            source = delegate?.pickerKeyboardNeedsSource?(self)
            if let source = source as? UIPickerViewDelegate {
                picker.delegate = source
            }
            if let source = source as? UIPickerViewDataSource {
                picker.dataSource = source
            }
        }
        picker.reloadAllComponents()
        picker.delegate?.pickerView?(picker, didSelectRow: picker.selectedRow(inComponent: 0), inComponent: 0)
    }
}
