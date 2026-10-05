//
//  BaseViewController.swift
//  PRKit
//
//  Created by Francis Li on 10/4/26.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    open weak var headerView: UIView!
    open weak var mainView: UIView!
    open weak var contentView: UIView!
    open var contentViewRightConstraint: NSLayoutConstraint!
    open weak var footerView: UIView!

    open weak var button: PRKit.Button!

    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .yellow
        headerView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(headerView)
        let headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 0)
        headerViewHeightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewHeightConstraint
        ])
        self.headerView = headerView

        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .green
        mainView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        self.mainView = mainView

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black.withAlphaComponent(0.5)
        mainView.addSubview(contentView)
        let contentViewCenterXConstraint = contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        contentViewCenterXConstraint.priority = .defaultHigh
        let contentViewWidthConstraint = contentView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        contentViewWidthConstraint.priority = .defaultHigh
        let contentViewRightConstraint = contentView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -100)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: mainView.layoutMarginsGuide.topAnchor),
            contentView.leftAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leftAnchor),
            contentView.rightAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.rightAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 780),
            contentView.bottomAnchor.constraint(equalTo: mainView.layoutMarginsGuide.bottomAnchor),
            contentViewCenterXConstraint,
            contentViewWidthConstraint,
            contentViewRightConstraint
        ])
        self.contentView = contentView
        self.contentViewRightConstraint = contentViewRightConstraint

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

        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .blue
        footerView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.addSubview(footerView)
        let footerViewHeightConstraint = footerView.heightAnchor.constraint(equalToConstant: 0)
        footerViewHeightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            mainView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerViewHeightConstraint
        ])
        self.footerView = footerView

        var testView = UIView()
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = .black.withAlphaComponent(0.5)
        headerView.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            testView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            testView.heightAnchor.constraint(equalToConstant: 64),
            headerView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: testView.bottomAnchor)
        ])

        testView = UIView()
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

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds.size.width > view.bounds.size.height {
            if traitCollection.horizontalSizeClass == .regular {
                contentViewRightConstraint.isActive = true
            } else {
                contentViewRightConstraint.isActive = false
            }
        } else {
            contentViewRightConstraint.isActive = false
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        button.setTitle(presentingViewController == nil ? "Open" : "Close", for: .normal)
    }

    @objc func buttonPressed() {
        if presentingViewController == nil {
            let vc = BaseViewController()
            present(vc, animated: true)
        } else {
            presentingViewController?.dismiss(animated: true)
        }
    }
}
