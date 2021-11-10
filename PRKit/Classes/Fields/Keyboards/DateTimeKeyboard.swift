//
//  DateTimeKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

@objc public protocol DateTimeKeyboardDelegate {
    @objc optional func dateTimeKeyboard(_ keyboard: DateTimeKeyboard, didChange value: Date)
}

open class DateTimeKeyboard: UIView {
    open weak var datePicker: UIDatePicker!
    weak var delegate: DateTimeKeyboardDelegate?

    open var date: Date {
        get { return datePicker.date }
        set { datePicker.date = newValue }
    }

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

    @objc func dateChanged() {
        delegate?.dateTimeKeyboard?(self, didChange: date)
    }
}
