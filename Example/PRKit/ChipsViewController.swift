//
//  ChipsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 2/22/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

class ChipsViewController: UIViewController, RecordingFieldDelegate {
    @IBOutlet weak var recordingField: RecordingField!

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingField.setDate(Date())
    }

    // MARK: - RecordingFieldDelegate

    func recordingField(_ field: RecordingField, didPressPlayButton button: UIButton) {
        if field.isPlaying {
            field.isPlaying = false
        } else {
            field.isPlaying = true
            field.isActivityIndicatorAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                field.isActivityIndicatorAnimating = false
            }
        }
    }
}
