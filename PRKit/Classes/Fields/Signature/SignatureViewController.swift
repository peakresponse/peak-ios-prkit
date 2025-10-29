//
//  SignatureViewController.swift
//  PRKit
//
//  Created by Francis Li on 9/16/22.
//

import Foundation
import UIKit
import SwiftSignatureView

@objc public protocol SignatureViewControllerDelegate: AnyObject {
    @objc optional func signatureViewController(_ vc: SignatureViewController, didSign image: UIImage)
}

open class SignatureViewController: UIViewController, SwiftSignatureViewDelegate {
    open weak var signatureView: SwiftSignatureView!

    open weak var delegate: SignatureViewControllerDelegate?

    open weak var doneButton: Button!
    open var doneButtonConstraints: [NSLayoutConstraint]!
    open weak var clearButton: Button!
    open var clearButtonConstraints: [NSLayoutConstraint]!
    open weak var cancelButton: Button!
    open var cancelButtonConstraints: [NSLayoutConstraint]!
    open weak var lineView: UIView!
    open var lineViewConstraints: [NSLayoutConstraint]!

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        if traitCollection.horizontalSizeClass == .compact {
            modalPresentationStyle = .fullScreen
            modalTransitionStyle = .flipHorizontal
        } else {
            modalPresentationStyle = .formSheet
            preferredContentSize = CGSize(width: 540, height: 300)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView(frame: self.view.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            view.widthAnchor.constraint(equalTo: self.view.heightAnchor),
            view.heightAnchor.constraint(equalTo: self.view.widthAnchor)
        ])

        if traitCollection.horizontalSizeClass == .compact {
            view.transform = CGAffineTransform(rotationAngle: -.pi/2)
        }

        let signatureView = SwiftSignatureView()
        signatureView.subviews[0].subviews[0].overrideUserInterfaceStyle = traitCollection.userInterfaceStyle
        signatureView.subviews[0].subviews[0].backgroundColor = .background
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        signatureView.delegate = self
        view.addSubview(signatureView)
        NSLayoutConstraint.activate([
            signatureView.topAnchor.constraint(equalTo: view.topAnchor),
            signatureView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signatureView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signatureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.signatureView = signatureView

        let doneButton = Button()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.isHidden = true
        doneButton.isEnabled = false
        doneButton.size = .small
        doneButton.style = .primary
        doneButton.setTitle("Button.done".localized, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButtonConstraints = [
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(doneButtonConstraints)
        self.doneButton = doneButton

        let clearButton = Button()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.isHidden = true
        clearButton.size = .small
        clearButton.style = .secondary
        clearButton.setTitle("Button.clear".localized, for: .normal)
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButtonConstraints = [
            clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(clearButtonConstraints)
        self.clearButton = clearButton

        let cancelButton = Button()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.isHidden = true
        cancelButton.size = .small
        cancelButton.style = .secondary
        cancelButton.setTitle("Button.cancel".localized, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButtonConstraints = [
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(cancelButtonConstraints)
        self.cancelButton = cancelButton

        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .disabledBorder
        lineView.isHidden = true
        view.addSubview(lineView)
        lineViewConstraints = [
            lineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            lineView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            lineView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(lineViewConstraints)
        self.lineView = lineView
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doneButton.isHidden = false
        clearButton.isHidden = false
        cancelButton.isHidden = false
        lineView.isHidden = false
    }

    open override func viewSafeAreaInsetsDidChange() {
        if traitCollection.horizontalSizeClass == .compact {
            doneButtonConstraints[1].constant = -20 - view.safeAreaInsets.top
            cancelButtonConstraints[1].constant = 20 + view.safeAreaInsets.bottom
            lineViewConstraints[1].constant = 20 + view.safeAreaInsets.bottom
            lineViewConstraints[2].constant = -20 - view.safeAreaInsets.top
        }
    }

    @objc func cancelPressed() {
        dismiss(animated: true)
    }

    @objc func clearPressed() {
        signatureView.clear()
        doneButton.isEnabled = false
    }

    @objc func donePressed() {
        if let signature = signatureView.getCroppedSignature() {
            delegate?.signatureViewController?(self, didSign: signature)
        }
        cancelPressed()
    }

    // MARK: - SwiftSignatureViewDelegate

    public func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {

    }

    public func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        doneButton.isEnabled = true
    }
}
