//
//  DateKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

open class DateKeyboard: FormInputView {
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
        datePicker.datePickerMode = .date
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

    open override func setValue(_ value: AnyObject?) {
        if let value = value as? String, let date = ISO8601DateFormatter.date(from: value) {
            self.date = date
        } else {
            date = Date()
            dateChanged()
        }
    }

    open override func text(for value: AnyObject?) -> String? {
        return ISO8601DateFormatter.date(from: value as? String)?.asDateString()
    }

    @objc func dateChanged() {
        delegate?.formInputView(self, didChange: date.asISO8601DateString() as AnyObject)
    }
}
