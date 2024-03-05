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

    @IBInspectable open var attributeKey: String?
    open var attributeValue: NSObject? {
        didSet {
            didUpdateAttributeValue()
        }
    }

    open func didUpdateAttributeValue() {
    }
}
