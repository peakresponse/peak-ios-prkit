//
//  TriageControl.swift
//  PRKit
//
//  Created by Francis Li on 5/19/22.
//

import UIKit

@IBDesignable
open class TriageControl: UIControl {
    open weak var stackView: UIStackView!
    open weak var currentView: UIView!
    open weak var updateButton: Button!
    open weak var currentChip: Chip!
    open weak var editingStackView: UIStackView!
    open var priorityButtons: [Button] = []
    open weak var cancelButton: Button!

    open var priority: TriagePriority? {
        didSet { updatePriority() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        self.stackView = stackView

        let currentView = UIView()
        currentView.isHidden = true
        stackView.addArrangedSubview(currentView)
        self.currentView = currentView

        let updateButton = Button()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.size = .small
        updateButton.style = .secondary
        updateButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        updateButton.setTitle("Button.updateStatus".localized, for: .normal)
        updateButton.addTarget(self, action: #selector(togglePressed), for: .touchUpInside)
        currentView.addSubview(updateButton)
        NSLayoutConstraint.activate([
            updateButton.topAnchor.constraint(equalTo: currentView.topAnchor),
            updateButton.rightAnchor.constraint(equalTo: currentView.rightAnchor),
            updateButton.bottomAnchor.constraint(equalTo: currentView.bottomAnchor)
        ])
        self.updateButton = updateButton

        let currentChip = Chip()
        currentChip.size = .medium
        currentChip.translatesAutoresizingMaskIntoConstraints = false
        currentView.addSubview(currentChip)
        NSLayoutConstraint.activate([
            currentChip.topAnchor.constraint(equalTo: currentView.topAnchor),
            currentChip.leftAnchor.constraint(equalTo: currentView.leftAnchor),
            currentChip.rightAnchor.constraint(equalTo: updateButton.leftAnchor, constant: -8),
            currentView.bottomAnchor.constraint(equalTo: currentChip.bottomAnchor)
        ])
        self.currentChip = currentChip

        let editingStackView = UIStackView()
        editingStackView.axis = .vertical
        editingStackView.alignment = .fill
        editingStackView.spacing = 8
        stackView.addArrangedSubview(editingStackView)
        self.editingStackView = editingStackView

        var row: UIStackView!
        for (i, priority) in TriagePriority.allCases.enumerated() {
            if i % 3 == 0 {
                row = UIStackView()
                row.axis = .horizontal
                row.alignment = .fill
                row.distribution = .fillEqually
                row.spacing = 8
                editingStackView.addArrangedSubview(row)
            } else if i >= 5 {
                break
            }
            let button = Button()
            button.tag = priority.rawValue
            button.size = .small
            button.style = .secondary
            button.setTitle(priority.description, for: .normal)
            button.setTitleAttributes(font: .body14Bold, color: .base800, for: .normal)
            button.setTitleAttributes(font: .body14Bold, color: priority.labelColor, for: .highlighted)
            button.setTitleAttributes(font: .body14Bold, color: priority.labelColor, for: .selected)
            button.setTitleAttributes(font: .body14Bold, color: priority.labelColor, for: [.selected, .highlighted])
            button.setBackgroundImage(.resizableImage(withColor: priority.lightenedColor, cornerRadius: 8,
                                                      borderColor: priority.color, borderWidth: 2), for: .normal)
            button.setBackgroundImage(.resizableImage(withColor: priority.color, cornerRadius: 8,
                                                      borderColor: priority.color, borderWidth: 2), for: .highlighted)
            button.setBackgroundImage(.resizableImage(withColor: priority.color, cornerRadius: 8,
                                                      borderColor: priority.color, borderWidth: 2), for: .selected)
            button.setBackgroundImage(.resizableImage(withColor: priority.color, cornerRadius: 8,
                                                      borderColor: priority.color, borderWidth: 2), for: [.selected, .highlighted])
            button.setBackgroundImage(.resizableImage(withColor: priority.lightenedColor, cornerRadius: 8,
                                                      borderColor: priority.lightenedColor, borderWidth: 2), for: .disabled)
            button.addTarget(self, action: #selector(priorityPressed(_:)), for: .touchUpInside)
            row.addArrangedSubview(button)
            priorityButtons.append(button)
        }
        let cancelButton = Button()
        cancelButton.alpha = 0
        cancelButton.size = .small
        cancelButton.style = .secondary
        cancelButton.setTitle("Button.cancel".localized, for: .normal)
        cancelButton.addTarget(self, action: #selector(togglePressed), for: .touchUpInside)
        row.addArrangedSubview(cancelButton)
        self.cancelButton = cancelButton
    }

    open func updatePriority() {
        if let priority = priority, priority != .unknown {
            currentChip.color = priority.color
            currentChip.setTitleColor(priority.labelColor, for: .normal)
            currentChip.setTitle(priority.description, for: .normal)
            currentView.isHidden = false
            editingStackView.isHidden = true
            cancelButton.alpha = 1
        } else {
            currentView.isHidden = true
            editingStackView.isHidden = false
            cancelButton.alpha = 0
        }
    }

    @objc func togglePressed() {
        currentView.isHidden = !currentView.isHidden
        cancelButton.alpha = priority == nil ? 0 : 1
        editingStackView.isHidden = !editingStackView.isHidden
    }

    @objc func priorityPressed(_ sender: Button) {
        if !sender.isSelected {
            for button in priorityButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            priority = TriagePriority(rawValue: sender.tag)
            sendActions(for: .valueChanged)
        } else {
            togglePressed()
        }
    }
}
