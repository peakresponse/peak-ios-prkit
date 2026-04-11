//
//  PickerKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

open class PickerKeyboard: FormInputView, UIPickerViewDelegate, UIPickerViewDataSource {
    private static weak var singleton: PickerKeyboard?
    public static var instance: PickerKeyboard {
        var instance = singleton
        if instance == nil {
            instance = PickerKeyboard()
            singleton = instance
        }
        return instance!
    }

    open weak var picker: UIPickerView!
    open var source: KeyboardSource? {
        didSet {
            picker?.reloadAllComponents()
        }
    }

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public convenience init(source: KeyboardSource) {
        self.init()
        self.source = source
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

    open override func setValue(_ value: NSObject?) {
        if let source = source, let value = value, let index = source.firstIndex(of: value) {
            picker.selectRow(index + 1, inComponent: 0, animated: false)
        } else {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }

    open override func text(for value: NSObject?) -> String? {
        return source?.title(for: value)
    }

    // MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (source?.count() ?? 0) + 1
    }

    // MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        return source?.title(at: row - 1)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var value: NSObject?
        if row > 0 {
            value = source?.value(at: row - 1)
        }
        delegate?.formInputView(self, didChange: value)
    }
}
