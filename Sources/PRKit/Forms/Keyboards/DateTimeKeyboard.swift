//
//  DateTimeKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

open class DateTimeKeyboard: FormInputView {
    private static weak var singleton: DateTimeKeyboard?
    public static var instance: DateTimeKeyboard {
        var instance = singleton
        if instance == nil {
            instance = DateTimeKeyboard()
            singleton = instance
        }
        return instance!
    }

    open weak var datePicker: UIDatePicker!

    open var date: Date {
        get { return datePicker.date }
        set { datePicker.date = newValue }
    }

    open override var shouldResignAfterClear: Bool {
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

        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leftAnchor.constraint(equalTo: leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: datePicker.bottomAnchor)
        ])
        self.datePicker = datePicker
    }

    open override func setValue(_ value: NSObject?) {
        if let value = value as? Date {
            date = value
        } else {
            date = Date()
            dateChanged()
        }
    }

    open override func text(for value: NSObject?) -> String? {
        return (value as? Date)?.asDateTimeString()
    }

    @objc func dateChanged() {
        delegate?.formInputView(self, didChange: date as NSObject?)
    }
}
