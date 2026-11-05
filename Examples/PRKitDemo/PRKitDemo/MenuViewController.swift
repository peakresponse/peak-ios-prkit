//
//  MenuViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 11/4/26.
//

import PRKit
import UIKit

private struct Screen {
    let title: String
    let vcType: UIViewController.Type?
}

private let screens: [Screen] = [
    Screen(title: "Branding", vcType: nil),
    Screen(title: "Buttons", vcType: nil),
    Screen(title: "Chips", vcType: nil),
    Screen(title: "Custom", vcType: nil),
    Screen(title: "Headers", vcType: nil),
    Screen(title: "Inputs", vcType: nil),
    Screen(title: "Keyboards", vcType: nil),
    Screen(title: "Tabs", vcType: TabsViewController.self),
    Screen(title: "Tables", vcType: nil)
]

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var tableView: SidebarTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = SidebarTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidebarItem", for: indexPath)
        if let cell = cell as? SidebarTableViewCell {
            cell.textLabel?.text = screens[indexPath.row].title
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        if let vcType = screens[indexPath.row].vcType {
            vc = vcType.init()
        } else {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: screens[indexPath.row].title)
        }
        guard let vc else { return }
        splitViewController?.setViewController(vc, for: .secondary)
        splitViewController?.show(.secondary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
