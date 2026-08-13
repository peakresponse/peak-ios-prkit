//
//  FormComponent.swift
//  PRKit
//
//  Created by Francis Li on 3/4/24.
//

import Foundation
import UIKit

@objc public protocol FormComponentDelegate {
    @objc optional func formComponentDidChange(_ component: FormComponent)
}

@IBDesignable
open class FormComponent: UIView {
    @IBOutlet open weak var delegate: FormComponentDelegate?

    open var source: NSObject?
    open var target: NSObject?

    open var status: PredictionStatus = .none {
        didSet { if status != oldValue { updateStyle() } }
    }
    @IBInspectable open var Status: String? {
        get { status.rawValue }
        set { status = PredictionStatus(rawValue: newValue ?? "") ?? .none }
    }

    @IBInspectable open var attributeKey: String?

    open var isMultiValue = false
    open var attributeRow: Int = 0
    open var attributeIndex: Int = 0
    open var attributeValues: [[NSObject?]] = [[nil]] {
        didSet {
            didUpdateAttributeValue()
        }
    }
    open var attributeValue: NSObject? {
        get { return attributeValues[attributeRow][attributeIndex] }
        set { attributeValues[attributeRow][attributeIndex] = newValue }
    }

    @IBInspectable open var isEditing: Bool = true {
        didSet {
            didUpdateEditing()
        }
    }

    @IBInspectable open var isEnabled: Bool = true {
        didSet {
            didUpdateEnabled()
        }
    }

    open override var inputAccessoryView: UIView? {
        get { nil }
        set { /* no-op */ }
    }

    open func didScrollIntoView(_ scrollView: UIScrollView) {
    }

    open func didUpdateAttributeValue() {
    }

    open func didUpdateEditing() {
    }

    open func didUpdateEnabled() {
    }

    open func updateStyle() {
    }
}
