//
//  RootViewController.swift
//  PRKitDemo
//
//  Created by Francis Li on 5/27/26.
//

import Foundation
import PRKit
import UIKit

class RootViewController: UITableViewController {
    let rows = [
        "Branding",
        "Buttons",
        "Chips",
        "Custom",
        "Headers",
        "Inputs",
        "Keyboards",
        "Navigation",
        "Tabs",
        "Tables"
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "PRKit"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView = SidebarTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidebarItem", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InputsViewController()
        showDetailViewController(vc, sender: self)
    }
}
