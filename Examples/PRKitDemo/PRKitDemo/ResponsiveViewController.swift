//
//  ResponsiveViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 10/7/26.
//

import PRKit
import UIKit

class ResponsiveViewController: BaseViewController, CommandHeaderDelegate, FormFieldDelegate {
    weak var commandHeader: CommandHeader!
    weak var commandFooter: CommandFooter!
    weak var sidebarTableView: SidebarTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.backgroundColor = .green
        contentView.backgroundColor = .black.withAlphaComponent(0.5)

        let commandHeader = CommandHeader()
        commandHeader.translatesAutoresizingMaskIntoConstraints = false
        commandHeader.preservesSuperviewLayoutMargins = true
        commandHeader.delegate = self
        commandHeader.initSearchField()
        commandHeader.searchFieldDelegate = self
        commandHeader.userImageURL = nil
        commandHeader.userLabelText = "UNIT: J. Doe"
        headerView.addSubview(commandHeader)
        NSLayoutConstraint.activate([
            commandHeader.topAnchor.constraint(equalTo: headerView.topAnchor),
            commandHeader.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            commandHeader.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            headerView.bottomAnchor.constraint(equalTo: commandHeader.bottomAnchor),
            commandHeader.contentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            commandHeader.contentView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        self.commandHeader = commandHeader

        let commandFooter = CommandFooter()
        commandFooter.translatesAutoresizingMaskIntoConstraints = false
        commandFooter.preservesSuperviewLayoutMargins = true
        footerView.addSubview(commandFooter)
        NSLayoutConstraint.activate([
            commandFooter.topAnchor.constraint(equalTo: footerView.topAnchor),
            commandFooter.leftAnchor.constraint(equalTo: footerView.leftAnchor),
            commandFooter.rightAnchor.constraint(equalTo: footerView.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: commandFooter.bottomAnchor),
        ])
        self.commandFooter = commandFooter

        let sidebarTableView = SidebarTableView()
        sidebarTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sidebarTableView)
        var sidebarTableViewConstraints = [
            sidebarTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            sidebarTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        sidebarTableViewConstraints.append(contentsOf: sidebarTableView.layoutConstraints(in: view))
        NSLayoutConstraint.activate(sidebarTableViewConstraints)
        self.sidebarTableView = sidebarTableView

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
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        self.button = button
    }

    override func updateFooterConstraints() {
        super.updateFooterConstraints()
        footerViewConstraints.append(contentsOf: commandFooter.layoutConstraints(for: contentView, in: view))
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

    // MARK: - CommandHeaderDelegate

    func commandHeaderDidPressUser(_ header: CommandHeader) {
        sidebarTableView.toggle()
    }
}
