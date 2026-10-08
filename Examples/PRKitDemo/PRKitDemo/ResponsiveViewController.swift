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
    weak var commandFooter: CommandFooter!

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
        self.welcomeHeader = welcomeHeader

        let commandFooter = CommandFooter()
        commandFooter.translatesAutoresizingMaskIntoConstraints = false
        commandFooter.preservesSuperviewLayoutMargins = true
        footerView.addSubview(commandFooter)
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: commandFooter.topAnchor),
            commandFooter.leftAnchor.constraint(equalTo: footerView.leftAnchor),
            commandFooter.rightAnchor.constraint(equalTo: footerView.rightAnchor),
            commandFooter.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            commandFooter.bottomContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            commandFooter.bottomContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        self.commandFooter = commandFooter

        var button = PRKit.Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.style = .primary
        button.setTitle("Primary", for: .normal)
        commandFooter.addSubview(button)

        button = PRKit.Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.style = .secondary
        button.setTitle("Secondary", for: .normal)
        commandFooter.addSubview(button)

        button = PRKit.Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.style = .primary
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        self.button = button
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
