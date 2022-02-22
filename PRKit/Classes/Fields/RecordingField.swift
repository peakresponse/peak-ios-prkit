//
//  RecordingField.swift
//  PRKit
//
//  Created by Francis Li on 2/21/22.
//

import UIKit

@IBDesignable
open class RecordingField: UIView {
    open weak var playButton: UIButton!
    open weak var titleLabel: UILabel!
    open weak var durationLabel: UILabel!
    open weak var dateTimeChip: Chip!
    open weak var textLabel: UILabel!

    @IBInspectable open var titleText: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    @IBInspectable open var durationText: String? {
        get { return durationLabel.text }
        set { durationLabel.text = newValue }
    }

    @IBInspectable open var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }

    open func setDate(_ date: Date) {

    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.brandPrimary300.cgColor

        let playButton = UIButton()
        playButton.tintColor = .brandPrimary500
        playButton.setImage(UIImage(named: "RecordPlay40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        playButton.setImage(UIImage(named: "RecordStop40px", in: PRKitBundle.instance, compatibleWith: nil), for: .selected)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            playButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.playButton = playButton

        let dateTimeChip = Chip()
        dateTimeChip.size = .small
        dateTimeChip.tintColor = .base500
        dateTimeChip.setImage(UIImage(named: "Clock24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        dateTimeChip.translatesAutoresizingMaskIntoConstraints = false
        dateTimeChip.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(dateTimeChip)
        NSLayoutConstraint.activate([
            dateTimeChip.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            dateTimeChip.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ])
        self.dateTimeChip = dateTimeChip

        let titleLabel = UILabel()
        titleLabel.font = .body14Bold
        titleLabel.textColor = .base500
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: dateTimeChip.leftAnchor, constant: -16)
        ])
        self.titleLabel = titleLabel

        let durationLabel = UILabel()
        durationLabel.font = .body14Bold
        durationLabel.textColor = .base800
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            durationLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            durationLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
        self.durationLabel = durationLabel

        let textLabel = UILabel()
        textLabel.font = .h4SemiBold
        textLabel.textColor = .base800
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            textLabel.leftAnchor.constraint(equalTo: durationLabel.leftAnchor),
            textLabel.rightAnchor.constraint(equalTo: dateTimeChip.rightAnchor),
            bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            bottomAnchor.constraint(greaterThanOrEqualTo: playButton.bottomAnchor, constant: 16)
        ])
        self.textLabel = textLabel
    }
}
