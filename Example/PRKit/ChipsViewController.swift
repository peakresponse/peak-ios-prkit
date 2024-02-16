//
//  ChipsViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 2/22/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import PRKit

class ChipsViewController: UIViewController, RecordingFieldDelegate, TriageCountsDelegate {
    @IBOutlet weak var recordingField: RecordingField!
    @IBOutlet weak var disabledCounterConrol: CounterControl!
    @IBOutlet weak var triageCountsView: TriageCounts!

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingField.setDate(Date())
        disabledCounterConrol.isEnabled = false
        triageCountsView.delegate = self
    }

    @IBAction func counterValueChanged(_ sender: CounterControl) {
        print("!!!", sender.count)
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

    // MARK: - TriageCountsDelegate

    func triageCounts(_ view: PRKit.TriageCounts, didPress button: PRKit.Button, with priority: PRKit.TriagePriority) {
        if let title = button.title(for: .normal), let count = Int(title) {
            view.setCount(count + 1, for: priority)
        }
    }

    func triageCounts(_ view: PRKit.TriageCounts, didPressTotal button: PRKit.Button) {
        for priority in PRKit.TriagePriority.allCases {
            view.setCount(0, for: priority)
        }
    }
}
