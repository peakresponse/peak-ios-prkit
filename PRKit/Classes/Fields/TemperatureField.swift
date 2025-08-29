//
//  TemperatureField.swift
//  Pods
//
//  Created by Francis Li on 8/28/25.
//

import UIKit

open class TemperatureField: FormComponent, FormComponentDelegate {
    open var fField: TextField!
    open var cField: TextField!

    open override var source: NSObject? {
        get { return cField.source }
        set {
            cField.source = newValue
            fField.source = newValue
        }
    }
    open override var target: NSObject? {
        get { return cField.target }
        set {
            cField.target = newValue
            fField.target = newValue
        }
    }

    open override var attributeKey: String? {
        get { return cField.attributeKey }
        set {
            cField.attributeKey = newValue
            if let newValue = newValue {
                fField.attributeKey = "\(newValue)F"
            } else {
                fField.attributeKey = nil
            }
        }
    }

    open override var inputAccessoryView: UIView? {
        get { return fField.inputAccessoryView }
        set {
            fField.inputAccessoryView = newValue
            cField.inputAccessoryView = newValue
        }
    }

    open var labelText: String? {
        didSet {
            fField.labelText = "\(labelText ?? "") (°F)"
            cField.labelText = "\(labelText ?? "") (°C)"
        }
    }

    open override var tag: Int {
        get { return 0 }
        set {
            fField.tag = newValue
            cField.tag = newValue + 1
        }
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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])

        let fField = TextField()
        fField.attributeType = .decimal
        fField.delegate = self
        stackView.addArrangedSubview(fField)
        self.fField = fField

        let cField = TextField()
        cField.attributeType = .decimal
        cField.delegate = self
        stackView.addArrangedSubview(cField)
        self.cField = cField
    }

    open override func reloadInputViews() {
        fField.reloadInputViews()
        cField.reloadInputViews()
    }

    open override func didUpdateAttributeValue() {
        cField.attributeValue = attributeValue
        // check for a corresponding F value
        let obj = source ?? target
        fField.attributeValue = obj?.value(forKeyPath: "\(attributeKey ?? "")F") as? NSObject
        // if none, convert
        if fField.attributeValue == nil {
            convertToFahrenheit()
        } else if cField.attributeValue == nil {
            convertToCelsius()
        }
    }

    open override func didUpdateEditing() {
        fField.isEditing = isEditing
        cField.isEditing = isEditing
    }

    open override func didUpdateEnabled() {
        fField.isEnabled = isEnabled
        cField.isEnabled = isEnabled
    }

    open func convertToCelsius() {
        if let text = fField.text, let value = Double(text) {
            let celsius = (value - 32) * 5 / 9
            cField.attributeValue = String(format: "%.1f", celsius) as NSString
        } else {
            cField.attributeValue = nil
        }
    }

    open func convertToFahrenheit() {
        if let text = cField.text, let value = Double(text) {
            let fahrenheit = (value * 9 / 5) + 32
            fField.attributeValue = String(format: "%.1f", fahrenheit) as NSString
        } else {
            fField.attributeValue = nil
        }
    }

    // MARK: - FormComponentDelegate

    @objc open func formComponentDidChange(_ component: FormComponent) {
        if component === fField {
            convertToCelsius()
            delegate?.formComponentDidChange?(cField)
        } else if component === cField {
            convertToFahrenheit()
            delegate?.formComponentDidChange?(fField)
        }
        delegate?.formComponentDidChange?(component)
    }
}
