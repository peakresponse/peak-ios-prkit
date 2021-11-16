//
//  DateKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/10/21.
//

import UIKit

open class DateKeyboard: UIView, FormFieldInputView {
    open weak var datePicker: UIDatePicker!
    open weak var delegate: FormFieldInputViewDelegate?

    open var date: Date {
        get { return datePicker.date }
        set { datePicker.date = newValue }
    }

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

    public func setValue(_ value: AnyObject?) {
        if let value = value as? String, let date = ISO8601DateFormatter.date(from: value) {
            self.date = date
        } else {
            date = Date()
            delegate?.formFieldInputView(self, didChange: date.asISO8601DateString() as AnyObject)
        }
    }

    @objc func dateChanged() {
        delegate?.formFieldInputView(self, didChange: date.asISO8601DateString() as AnyObject)
    }
}
