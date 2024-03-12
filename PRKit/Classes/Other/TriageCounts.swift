//
//  TriageCounts.swift
//  PRKit
//
//  Created by Francis Li on 11/8/23.
//

import UIKit

public protocol TriageCountsDelegate: AnyObject {
    func triageCounts(_ view: TriageCounts, didPress button: Button, with priority: TriagePriority)
    func triageCounts(_ view: TriageCounts, didPressTotal button: Button)
}

open class TriageCounts: UIStackView {
    open weak var delegate: TriageCountsDelegate?
    open var totalButton: Button!
    open var priorityButtons: [Button] = []
    open var size: ButtonSize = .small
    open var isExpectantHidden = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 8

        var row = UIStackView()
        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = 8
        addArrangedSubview(row)

        for priority in TriagePriority.allCases {
            let button = Button()
            button.tag = priority.rawValue
            button.size = size
            button.style = .secondary
            button.titleLabel?.font = .h4SemiBold
            button.setTitle("0", for: .normal)
            if size == .small {
                button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 2, bottom: 13, right: 2)
            }
            button.setTitleColor(.base800, for: .normal)
            button.setTitleColor(priority.labelColor, for: .highlighted)
            button.setTitleColor(priority.labelColor, for: .selected)
            button.setTitleColor(priority.labelColor, for: [.selected, .highlighted])
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
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            priorityButtons.append(button)
            setCount(0, for: priority)
            if priority == .expectant && isExpectantHidden {
                continue
            } else if priority == .transported {
                break
            }
            row.addArrangedSubview(button)
        }

        row = UIStackView()
        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = 8
        addArrangedSubview(row)

        totalButton = Button()
        totalButton.tag = -1
        totalButton.size = size
        totalButton.style = .secondary
        totalButton.titleLabel?.font = .h4SemiBold
        if size == .small {
            totalButton.contentEdgeInsets = UIEdgeInsets(top: 13, left: 2, bottom: 13, right: 2)
        }
        totalButton.setTitleColor(.base800, for: .normal)
        totalButton.setTitleColor(.white, for: .highlighted)
        totalButton.setTitleColor(.white, for: .selected)
        totalButton.setTitleColor(.white, for: [.highlighted, .selected])
        totalButton.setBackgroundImage(.resizableImage(withColor: .white, cornerRadius: 8,
                                                  borderColor: .base500, borderWidth: 2), for: .normal)
        totalButton.setBackgroundImage(.resizableImage(withColor: .base500, cornerRadius: 8,
                                                  borderColor: .base500, borderWidth: 2), for: .highlighted)
        totalButton.setBackgroundImage(.resizableImage(withColor: .base500, cornerRadius: 8,
                                                  borderColor: .base500, borderWidth: 2), for: .selected)
        totalButton.setBackgroundImage(.resizableImage(withColor: .base500, cornerRadius: 8,
                                                  borderColor: .base500, borderWidth: 2), for: [.selected, .highlighted])
        totalButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        row.addArrangedSubview(totalButton)
        setTotalCount(0)

        if let transportedButton = priorityButtons.last {
            transportedButton.setTitle(String(format: "TriageCounts.transported".localized, 0), for: .normal)
            row.addArrangedSubview(transportedButton)
        }
    }

    open func setCount(_ count: Int, for priority: TriagePriority) {
        let index = priority.rawValue
        if index >= 0 && index <= TriagePriority.dead.rawValue {
            priorityButtons[index].setTitle("\(count)", for: .normal)
        } else if index == TriagePriority.transported.rawValue {
            priorityButtons[index].setTitle(String(format: "TriageCounts.transported".localized, count), for: .normal)
        }
    }

    open func setTotalCount(_ count: Int) {
        totalButton.setTitle(String(format: "TriageCounts.total".localized, count), for: .normal)
    }

    @objc func buttonPressed(_ sender: Button) {
        if sender == totalButton {
            delegate?.triageCounts(self, didPressTotal: sender)
        } else if let priority = TriagePriority(rawValue: sender.tag) {
            delegate?.triageCounts(self, didPress: sender, with: priority)
        }
    }
}
