//
//  ComboKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 12/13/21.
//

import Foundation

open class ComboKeyboard: FormInputView, FormInputViewDelegate {
    open var keyboards: [FormInputView] = []
    open var titles: [String] = []
    open var currentIndex = 0
    open var values: [AnyObject?] = []

    public init(keyboards: [FormInputView], titles: [String]) {
        self.keyboards = keyboards
        self.titles = titles
        super.init()
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        for keyboard in keyboards {
            keyboard.translatesAutoresizingMaskIntoConstraints = false
            keyboard.isHidden = true
            keyboard.delegate = self
            addSubview(keyboard)
            NSLayoutConstraint.activate([
                keyboard.topAnchor.constraint(equalTo: topAnchor),
                keyboard.leftAnchor.constraint(equalTo: leftAnchor),
                keyboard.rightAnchor.constraint(equalTo: rightAnchor),
                keyboard.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        keyboards[0].isHidden = false
    }

    open override func setValue(_ value: AnyObject?) {
        if let values = value as? [AnyObject?] {
            self.values = values
        } else {
            values = [AnyObject?](repeating: nil, count: keyboards.count)
        }
        for (i, value) in values.enumerated() {
            keyboards[i].setValue(value)
        }
    }

    open override func text(for value: AnyObject?) -> String? {
        if let values = value as? [AnyObject?] {
            return values.enumerated().compactMap { keyboards[$0].text(for: $1) }.joined(separator: " ")
        }
        return nil
    }

    open override var shouldResignAfterClear: Bool {
        return keyboards.reduce(false, { $0 || $1.shouldResignAfterClear })
    }

    open override var accessoryOtherButtonTitle: String? {
        return titles[(currentIndex + 1) % keyboards.count]
    }

    open override func accessoryOtherButtonPressed(_ inputAccessoryView: FormInputAccessoryView) -> String? {
        keyboards[currentIndex].isHidden = true
        currentIndex = (currentIndex + 1) % keyboards.count
        keyboards[currentIndex].isHidden = false
        return accessoryOtherButtonTitle
    }

    // MARK: - FormInputViewDelegate

    open func formInputView(_ inputView: FormInputView, didChange value: AnyObject?) {
        if let index = keyboards.firstIndex(of: inputView) {
            values[index] = value
            delegate?.formInputView(self, didChange: values as AnyObject)
        }
    }

    open func formInputView(_ inputView: FormInputView, wantsToPresent vc: UIViewController) {
        delegate?.formInputView(self, wantsToPresent: vc)
    }
}
