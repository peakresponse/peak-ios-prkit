//
//  NumberAndUnitKeypad.swift
//  PRKit
//
//  Created by Francis Li on 1/11/22.
//

import UIKit

class NumberAndUnitKeypad: ComboKeyboard {
    open override weak var textView: UITextView! {
        get { return keyboards[0].textView }
        set { keyboards[0].textView = newValue }
    }

    open override var isTextViewEditable: Bool {
        return true
    }

    open var isDecimalHidden: Bool {
        get { return (keyboards[0] as? NumberKeypad)?.isDecimalHidden ?? false }
        set { (keyboards[0] as? NumberKeypad)?.isDecimalHidden = newValue }
    }

    open var unitSource: KeyboardSource? {
        get { return (keyboards[1] as? SelectKeyboard)?.source }
        set { (keyboards[1] as? SelectKeyboard)?.source = newValue }
    }

    public init() {
        super.init(keyboards: [
            NumberKeypad.instance,
            SelectKeyboard()
        ], titles: ["123", "Unit"])
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setValue(_ value: NSObject?) {
        if var values = value as? [NSObject?] {
            if values.count == 0 {
                values.append(nil)
            }
            if values.count == 1 {
                values.append(unitSource?.value(at: 0))
            }
            if (values[1] as? String)?.isEmpty ?? (values[1] == nil) {
                values[1] = unitSource?.value(at: 0)
            }
            self.values = values
        } else {
            values = [nil, unitSource?.value(at: 0)]
        }
        for (i, value) in values.enumerated() {
            keyboards[i].setValue(value)
        }
    }

    open override var accessoryOtherButtonTitle: String? {
        switch currentIndex {
        case 0:
            return unitSource?.title(for: values[1]) ?? unitSource?.title(at: 0)
        case 1:
            return "123"
        default:
            return nil
        }
    }

    open override func text(for value: NSObject?) -> String? {
        if let value = value as? [String?], value.count > 0 {
            return value[0]
        }
        return nil
    }

    open override func unitText(for value: NSObject?) -> String? {
        if let value = value as? [NSObject?], value.count == 2, let unit = unitSource?.title(for: value[1]) {
            return " \(unit)"
        }
        return nil
    }
}
