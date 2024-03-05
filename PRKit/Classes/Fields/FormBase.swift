//
//  FormBase.swift
//  PRKit
//
//  Created by Francis Li on 3/4/24.
//

import Foundation
import UIKit

@IBDesignable
open class FormBase: UIView {
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
