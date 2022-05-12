//
//  ModalViewController.swift
//  PRKit
//
//  Created by Francis Li on 4/22/22.
//

import UIKit

typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

open class ModalViewController: UIViewController {
    open weak var backdropView: UIView!
    open weak var tapRecognizer: UITapGestureRecognizer!
    open weak var contentView: UIView!
    open weak var cancelButton: UIButton!
    open weak var messageLabel: UILabel!
    open weak var buttonStackView: UIStackView!
    open var actions: [UIAlertAction] = []
    open var isDismissedOnAction = true

    open var messageText: String? {
        didSet { messageLabel?.text = messageText }
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.backgroundColor = .base300
        backdropView.alpha = 0.7
        view.addSubview(backdropView)
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backdropView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelPressed))
        backdropView.addGestureRecognizer(tapRecognizer)
        self.backdropView = backdropView
        self.tapRecognizer = tapRecognizer

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.addShadow(withOffset: CGSize(width: 0, height: 6), radius: 10, color: .base800, opacity: 0.15)
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 235)
        ])
        if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.widthAnchor.constraint(equalToConstant: 335)
            ])
        }
        self.contentView = contentView

        let cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.tintColor = .base800
        cancelButton.setImage(UIImage(named: "Exit24px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cancelButton.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        self.cancelButton = cancelButton

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .h4SemiBold
        messageLabel.numberOfLines = 0
        messageLabel.text = messageText
        messageLabel.textAlignment = .center
        messageLabel.textColor = .base800
        contentView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 16),
            messageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25)
        ])
        self.messageLabel = messageLabel

        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        contentView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            contentView.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 40)
        ])
        self.buttonStackView = buttonStackView

        for (tag, action) in actions.enumerated() {
            let button = PRKit.Button()
            button.tag = tag
            switch action.style {
            case .destructive:
                button.style = .destructive
            case .cancel:
                button.style = .secondary
            default:
                button.style = .primary
            }
            button.setTitle(action.title, for: .normal)
            button.addTarget(self, action: #selector(actionPressed(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }

    @objc func cancelPressed() {
        dismiss(animated: true)
    }

    @objc func actionPressed(_ button: PRKit.Button) {
        let action = actions[button.tag]
        if let block = action.value(forKey: "handler") {
            let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
            if isDismissedOnAction {
                dismiss(animated: true) {
                    handler(action)
                }
            } else {
                // hide all the buttons
                cancelButton.alpha = 0
                for view in buttonStackView.arrangedSubviews {
                    if let button = view as? PRKit.Button {
                        button.alpha = 0
                    }
                }
                tapRecognizer.isEnabled = false
                // put an activity spinner over the selected button
                let activityIndicatorView = UIActivityIndicatorView.withLargeStyle()
                activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                activityIndicatorView.tintColor = .base800
                view.addSubview(activityIndicatorView)
                NSLayoutConstraint.activate([
                    activityIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                    activityIndicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])
                activityIndicatorView.startAnimating()
                handler(action)
            }
        } else {
            dismiss(animated: true)
        }
    }

    open func addAction(_ action: UIAlertAction) {
        actions.append(action)
    }
}
