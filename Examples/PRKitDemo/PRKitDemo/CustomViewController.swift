//
//  CustomViewController.swift
//  PRKit
//
//  Created by Francis Li on 8/26/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import PRKit
import UIKit

final class CustomViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20)
        ])

        let inputAccessoryView = FormInputAccessoryView(rootView: view)

        let tempField = TemperatureField()
        tempField.labelText = "Temp."
        tempField.translatesAutoresizingMaskIntoConstraints = false
        tempField.tag = 1
        tempField.inputAccessoryView = inputAccessoryView
        stackView.addArrangedSubview(tempField)
    }
}
