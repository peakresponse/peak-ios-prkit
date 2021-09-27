//
//  BaseField.swift
//  PRKit
//
//  Created by Francis Li on 9/24/21.
//

import UIKit

enum FormFieldStyle: String {
    case input, onboarding
}

@objc protocol FormFieldDelegate {
    @objc optional func formFieldShouldBeginEditing(_ field: BaseField) -> Bool
    @objc optional func formFieldDidBeginEditing(_ field: BaseField)
    @objc optional func formFieldShouldEndEditing(_ field: BaseField) -> Bool
    @objc optional func formFieldDidEndEditing(_ field: BaseField)
    @objc optional func formFieldShouldReturn(_ field: BaseField) -> Bool
    @objc optional func formFieldDidChange(_ field: BaseField)
    @objc optional func formFieldDidConfirmStatus(_ field: BaseField)
}

class BaseField: UIView, Localizable {
    weak var contentView: UIView!

    weak var statusButton: UIButton!
    var statusButtonWidthConstraint: NSLayoutConstraint!
    weak var label: UILabel!

    private var _detailLabel: UILabel!
    var detailLabel: UILabel {
        if _detailLabel == nil {
            initDetailLabel()
        }
        return _detailLabel
    }
    private var _alertLabel: UILabel!
    var alertLabel: UILabel {
        if _alertLabel == nil {
            initAlertLabel()
        }
        return _alertLabel
    }
    private var _statusLabel: UILabel!
    var statusLabel: UILabel {
        if _statusLabel == nil {
            initStatusLabel()
        }
        return _statusLabel
    }

    var status: PredictionStatus = .none {
        didSet { updateStyle() }
    }

    @objc var text: String?
    @objc var placeholderText: String?

    @IBOutlet weak var delegate: FormFieldDelegate?

    @IBInspectable var l10nKey: String? {
        get { return nil }
        set { label.l10nKey = newValue }
    }

    @IBInspectable var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    @IBInspectable var attributeKey: String?

    @IBInspectable var isPlainText: Bool = false {
        didSet { updateStyle() }
    }

    var isEditing = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        updateStyle()
    }

    // swiftlin:disable:next function_body_length
    func commonInit() {
        backgroundColor = .clear

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.contentView = contentView

        let statusButton = UIButton()
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.addTarget(self, action: #selector(statusPressed), for: .touchUpInside)
        statusButton.backgroundColor = .middlePeakBlue
        contentView.addSubview(statusButton)
        statusButtonWidthConstraint = statusButton.widthAnchor.constraint(equalToConstant: 8)
        NSLayoutConstraint.activate([
            statusButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            statusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statusButtonWidthConstraint
        ])
        self.statusButton = statusButton

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lowPriorityGrey
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.leftAnchor.constraint(equalTo: statusButton.rightAnchor, constant: 10)
        ])
        self.label = label
    }

    private func initAlertLabel() {
        _alertLabel = UILabel()
        _alertLabel.translatesAutoresizingMaskIntoConstraints = false
        _alertLabel.font = .copyXSBold
        _alertLabel.textColor = .orangeAccent
        addSubview(_alertLabel)
        NSLayoutConstraint.activate([
            _alertLabel.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor),
            _alertLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
    }

    private func initStatusLabel() {
        _statusLabel = UILabel()
        _statusLabel.translatesAutoresizingMaskIntoConstraints = false
        _statusLabel.font = .copyXSBold
        _statusLabel.text = "BaseField.statusLabel.unconfirmed".localized
        _statusLabel.textAlignment = .right
        _statusLabel.textColor = .orangeAccent
        _statusLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(_statusLabel)
        NSLayoutConstraint.activate([
            _statusLabel.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor),
            _statusLabel.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
            _statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
    }

    private func initDetailLabel() {
        _detailLabel = UILabel()
        _detailLabel.translatesAutoresizingMaskIntoConstraints = false
        _detailLabel.font = .copyXSRegular
        _detailLabel.textColor = .mainGrey
        addSubview(_detailLabel)
        NSLayoutConstraint.activate([
            _detailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            _detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
    }

    // swiftlint:disable:next function_body_length
    func updateStyle() {
        if isPlainText {
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderWidth = 2
            contentView.layer.cornerRadius = 8
            if isFirstResponder {
                contentView.layer.borderColor = UIColor.brandPrimary500.cgColor
                contentView.addOutline(size: 4, color: .brandPrimary200, opacity: 1)
            } else {
                contentView.layer.borderColor = UIColor.brandPrimary300.cgColor
                contentView.removeOutline()
            }
        }

        label.font = .copyXSBold
        statusButton.backgroundColor = status == .unconfirmed ? UIColor.orangeAccent.withAlphaComponent(0.3) : UIColor.middlePeakBlue
        statusButton.isUserInteractionEnabled = isEditing && status == .unconfirmed
        statusButton.setImage(isEditing && status == .unconfirmed ? UIImage(named: "Unconfirmed") : nil, for: .normal)
        _statusLabel?.isHidden = true
        _alertLabel?.alpha = 1

        if status == .none || text?.isEmpty ?? true {
            statusButtonWidthConstraint.constant = 0
        } else if isEditing && status == .unconfirmed {
            statusButtonWidthConstraint.constant = 33
        } else {
            statusButtonWidthConstraint.constant = 8
        }
    }

    @objc func statusPressed() {
        delegate?.formFieldDidConfirmStatus?(self)
        status = .confirmed
        updateStyle()
    }
}
