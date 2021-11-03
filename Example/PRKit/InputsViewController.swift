//
//  InputsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 11/3/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PRKit
import UIKit

class InputsViewController: UIViewController, FormFieldDelegate {
    // MARK: - FormFieldDelegate

    func formFieldDidChange(_ field: FormField) {
        print(field.text ?? "")
    }
}
