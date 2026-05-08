//
//  CellField.swift
//  PRKit
//
//  Created by Francis Li on 9/21/22.
//

import Foundation
import UIKit

@IBDesignable
open class CellField: FormField {
    open weak var textLabel: UILabel!
    open weak var disclosureIndicatorView: UIImageView!

    @IBInspectable open override var text: String? {
        get { return textLabel.text }
        set {
            textLabel.text = newValue
            updateStyle()
        }
    }

    open override func commonInit() {
        super.commonInit()

        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .h4SemiBold
        textLabel.textColor = .text
        textLabel.numberOfLines = 0
        contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            textLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 12)
        ])
        self.textLabel = textLabel

        let disclosureIndicatorView = UIImageView()
        disclosureIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        disclosureIndicatorView.image = UIImage(named: "ChevronRight24px", in: PRKitBundle.instance, compatibleWith: nil)
        disclosureIndicatorView.tintColor = .labelText
        contentView.addSubview(disclosureIndicatorView)
        NSLayoutConstraint.activate([
            textLabel.rightAnchor.constraint(equalTo: disclosureIndicatorView.leftAnchor, constant: -6),
            disclosureIndicatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            disclosureIndicatorView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor)
        ])
        self.disclosureIndicatorView = disclosureIndicatorView

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewPressed(_:)))
        addGestureRecognizer(recognizer)
    }

    @IBAction open func viewPressed(_ sender: UIGestureRecognizer) {
        (delegate as? FormFieldDelegate)?.formFieldDidPress?(self)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderedView.backgroundColor = .highlight
        borderedView.layer.borderColor = UIColor.focusedBorder.cgColor
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderedView.backgroundColor = .textBackground
        borderedView.layer.borderColor = UIColor.border.cgColor
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderedView.backgroundColor = .textBackground
        borderedView.layer.borderColor = UIColor.border.cgColor
    }
}
