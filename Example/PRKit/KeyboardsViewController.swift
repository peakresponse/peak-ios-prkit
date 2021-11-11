//
//  KeyboardsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

enum PickerTestEnum: String, RawStringRepresentable, CustomStringConvertible, CaseIterable {
    case option1, option2, option3

    var description: String {
        switch self {
        case .option1:
            return "Option 1"
        case .option2:
            return "Option 2"
        case .option3:
            return "Option 3"
        }
    }
}

class KeyboardsViewController: UIViewController, FormFieldDelegate {
    @IBOutlet weak var dateTimeField: TextField!
    @IBOutlet weak var pickerField: TextField!

    func formField(_ field: FormField, needsSourceFor pickerKeyboard: PickerKeyboard) -> AnyObject? {
        if field == pickerField {
            return PickerKeyboardSource<PickerTestEnum>(pickerKeyboard: pickerKeyboard)
        }
        return nil
    }
}
