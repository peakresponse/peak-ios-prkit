//
//  SignatureField.swift
//  PRKit
//
//  Created by Francis Li on 9/15/22.
//

import Foundation
import UIKit

@IBDesignable
open class SignatureField: FormField, SignatureViewControllerDelegate {
    open weak var signatureView: UIImageView!
    open weak var signButton: Button!
    open weak var clearButton: UIButton!

    open var signatureImage: UIImage? {
        get {
            return signatureView.image
        }
        set {
            signatureView.image = newValue
            updateStyle()
        }
    }

    override open func commonInit() {
        super.commonInit()

        let signatureView = UIImageView()
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        signatureView.contentMode = .scaleAspectFit
        contentView.addSubview(signatureView)
        NSLayoutConstraint.activate([
            signatureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            signatureView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            signatureView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            signatureView.heightAnchor.constraint(equalToConstant: 74),
            contentView.bottomAnchor.constraint(equalTo: signatureView.bottomAnchor)
        ])
        self.signatureView = signatureView

        let signButton = Button()
        signButton.translatesAutoresizingMaskIntoConstraints = false
        signButton.style = .tertiary
        signButton.size = .medium
        signButton.setTitle("Button.tapToSign".localized, for: .normal)
        signButton.addTarget(self, action: #selector(signPressed), for: .touchUpInside)
        contentView.addSubview(signButton)
        NSLayoutConstraint.activate([
            signButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        self.signButton = signButton

        let clearButton = UIButton(type: .custom)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(named: "Exit24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        clearButton.imageView?.tintColor = .base800
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearInternalPressed), for: .touchUpInside)
        contentView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            clearButton.centerYAnchor.constraint(equalTo: signatureView.centerYAnchor)
        ])
        self.clearButton = clearButton
    }

    override open func updateStyle() {
        super.updateStyle()
        signButton.isHidden = signatureImage != nil || !isEnabled
        clearButton.isHidden = signatureImage == nil || !isEnabled
    }

    @objc open func signPressed() {
        let vc = SignatureViewController()
        vc.delegate = self
        (delegate as? FormFieldDelegate)?.formField?(self, wantsToPresent: vc)
    }

    @objc override open func clearPressed() {
        signatureImage = nil
        super.clearPressed()
    }

    @objc open func clearInternalPressed() {
        let vc = UIAlertController(title: "SignatureField.clearSignature.title".localized,
                                   message: "SignatureField.clearSignature.message".localized,
                                   preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Button.no".localized, style: .cancel))
        vc.addAction(UIAlertAction(title: "Button.yes".localized, style: .destructive, handler: { [weak self] (_) in
            self?.clearPressed()
        }))
        (delegate as? FormFieldDelegate)?.formField?(self, wantsToPresent: vc)
    }

    // MARK: - SignatureViewControllerDelegate

    public func signatureViewController(_ vc: SignatureViewController, didSign image: UIImage) {
        signatureImage = image
        delegate?.formComponentDidChange?(self)
    }
}
