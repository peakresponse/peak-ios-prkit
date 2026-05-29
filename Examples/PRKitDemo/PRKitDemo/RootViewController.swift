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
    let rows: [(String, UIViewController.Type?)] = [
        ("Branding", nil),
        ("Buttons", nil),
        ("Chips", nil),
        ("Custom", nil),
        ("Headers", nil),
        ("Inputs", InputsViewController.self),
        ("Keyboards", KeyboardsViewController.self),
        ("Navigation", nil),
        ("Tabs", nil),
        ("Tables", nil)
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
        cell.textLabel?.text = rows[indexPath.row].0
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = rows[indexPath.row].1 {
            let vc = type.init()
            showDetailViewController(vc, sender: self)
        }
    }
}
