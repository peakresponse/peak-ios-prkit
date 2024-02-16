//
//  FormInputView.swift
//  PRKit
//
//  Created by Francis Li on 11/30/21.
//

import UIKit

@objc public protocol FormInputViewDelegate: AnyObject {
    func formInputView(_ inputView: FormInputView, didChange value: NSObject?)
    func formInputView(_ inputView: FormInputView, wantsToPresent vc: UIViewController)
}

open class FormInputView: UIInputView {
    open weak var delegate: FormInputViewDelegate?

    open weak var textView: UITextView!

    open var isTextViewEditable: Bool {
        return false
    }

    public init() {
        super.init(frame: .zero, inputViewStyle: .keyboard)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open func setValue(_ value: NSObject?) {

    }

    open func text(for value: NSObject?) -> String? {
        return value as? String
    }

    open func unitText(for value: NSObject?) -> String? {
        return nil
    }

    open var shouldResignAfterClear: Bool {
        return false
    }

    open var accessoryOtherButtonTitle: String? {
        return nil
    }

    open func accessoryOtherButtonPressed(_ inputAccessoryView: FormInputAccessoryView) -> String? {
        return nil
    }
}
