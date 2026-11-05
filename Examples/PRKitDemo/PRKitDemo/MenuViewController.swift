//
//  MenuViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 11/4/26.
//

import PRKit
import UIKit

struct Screen {
    let label: String
    let vc: UIViewController.Type?
}

let screens: [Screen] = [
    Screen(label: "Branding", vc: nil),
    Screen(label: "Buttons", vc: nil),
    Screen(label: "Chips", vc: nil),
    Screen(label: "Custom", vc: nil),
    Screen(label: "Headers", vc: nil),
    Screen(label: "Inputs", vc: nil),
    Screen(label: "Keyboards", vc: nil),
    Screen(label: "Navigation", vc: nil),
    Screen(label: "Tabs", vc: nil),
    Screen(label: "Tables", vc: nil)
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
            cell.textLabel?.text = screens[indexPath.row].label
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        if let vc = screens[indexPath.row].vc {
            // TODO: instantiate
        } else {
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: screens[indexPath.row].label)
        }
        guard let vc else { return }
        splitViewController?.setViewController(vc, for: .secondary)
        splitViewController?.show(.secondary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
