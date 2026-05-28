//
//  AutocompleteTextField.swift
//  PRKit
//
//  Created by Francis Li on 5/27/26.
//

import Foundation
import UIKit

class AutocompleteDropdownView: UIView, UITableViewDataSource, UITableViewDelegate {
    let sources: [KeyboardSource]!
    var sourceIndex = 0
    var stackView: UIStackView!
    var segmentedControl: SegmentedControl?
    var tableView: TableView!
    
    init(sources: [KeyboardSource]) {
        self.sources = sources
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func commonInit() {
        backgroundColor = .background
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        if sources.count > 1 {
            let segmentedControl = SegmentedControl()
            for source in sources {
                segmentedControl.addSegment(title: source.name)
            }
            stackView.addArrangedSubview(segmentedControl)
        }

        tableView = TableView()
        tableView.backgroundColor = .white
        tableView.layer.borderColor = UIColor.focusedBorder.cgColor
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "Item")
        stackView.addArrangedSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources[sourceIndex].count()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        if let cell = cell as? ListItemTableViewCell {
            cell.label.text = sources[sourceIndex].title(at: indexPath.row)
        }
        return cell
    }
}

open class AutocompleteTextField: TextField {
    public var sources: [KeyboardSource] = []
    var sourceIndex = 0
    
    var dropdownView: AutocompleteDropdownView?
    
    override public func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
        if dropdownView == nil {
            let dropdownView = AutocompleteDropdownView(sources: sources)
            dropdownView.translatesAutoresizingMaskIntoConstraints = false
            self.dropdownView = dropdownView
        }
        if let dropdownView {
            var superview: UIView? = superview
            while !(superview is UIScrollView) && superview != nil {
                superview = superview?.superview
            }
            if let scrollView = superview as? UIScrollView {
                scrollView.isScrollEnabled = false
                scrollView.contentInset = .init(top: 0, left: 0, bottom: scrollView.frame.height, right: 0)
                scrollView.setContentOffset(CGPoint(x: 0, y: -(scrollView.safeAreaInsets.top - frame.origin.y)), animated: true)
                scrollView.addSubview(dropdownView)
                NSLayoutConstraint.activate([
                    dropdownView.topAnchor.constraint(equalTo: bottomAnchor, constant: 4),
                    dropdownView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    dropdownView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    dropdownView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -4),
                ])
            }
        }
    }
    
    override public func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        var superview: UIView? = superview
        while !(superview is UIScrollView) && superview != nil {
            superview = superview?.superview
        }
        if let scrollView = superview as? UIScrollView {
            scrollView.contentInset = .zero
            scrollView.isScrollEnabled = true
        }
        dropdownView?.removeFromSuperview()
    }
}
