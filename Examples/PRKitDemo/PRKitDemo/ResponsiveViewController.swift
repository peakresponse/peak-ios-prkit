//
//  ResponsiveViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 10/7/26.
//

import PRKit
import UIKit

class ResponsiveViewController: BaseViewController {
    weak var welcomeHeader: WelcomeHeader!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        headerView.backgroundColor = .yellow
        mainView.backgroundColor = .green
        contentView.backgroundColor = .black.withAlphaComponent(0.5)
        footerView.backgroundColor = .blue

        let welcomeHeader = WelcomeHeader()
        welcomeHeader.translatesAutoresizingMaskIntoConstraints = false
        welcomeHeader.labelText = "Welcome John Doe. Here's some really long text to test truncation/wrapping."
        welcomeHeader.preservesSuperviewLayoutMargins = true
        headerView.addSubview(welcomeHeader)
        NSLayoutConstraint.activate([
            welcomeHeader.topAnchor.constraint(equalTo: headerView.topAnchor),
            welcomeHeader.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            welcomeHeader.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            headerView.bottomAnchor.constraint(equalTo: welcomeHeader.bottomAnchor),
            welcomeHeader.contentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            welcomeHeader.contentView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        let button = PRKit.Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.style = .primary
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        self.button = button
//
//        var testView = UIView()
//        testView.translatesAutoresizingMaskIntoConstraints = false
//        testView.backgroundColor = .black.withAlphaComponent(0.5)
//        headerView.addSubview(testView)
//        NSLayoutConstraint.activate([
//            testView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            testView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            testView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            testView.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor)
//        ])

        let testView = UIView()
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = .black.withAlphaComponent(0.5)
        footerView.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            testView.heightAnchor.constraint(equalToConstant: 64),
            footerView.layoutMarginsGuide.topAnchor.constraint(equalTo: testView.topAnchor),
        ])
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        button.setTitle(presentingViewController == nil ? "Open" : "Close", for: .normal)
    }

    @objc func buttonPressed() {
        if presentingViewController == nil {
            let vc = ResponsiveViewController()
            present(vc, animated: true)
        } else {
            presentingViewController?.dismiss(animated: true)
        }
    }
}
