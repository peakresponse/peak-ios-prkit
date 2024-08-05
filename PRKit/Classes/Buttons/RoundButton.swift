//
//  RoundButton.swift
//  PRKit
//
//  Created by Francis Li on 2/20/24.
//

import Foundation
import UIKit

@IBDesignable
open class RoundButton: UIButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        addShadow(withOffset: CGSize(width: 5, height: 5), radius: 10, color: .dropShadow, opacity: 0.4)
        let size = floor(min(frame.size.width, frame.size.height) / 2)
        setBackgroundImage(UIImage.resizableImage(withColor: .primaryButtonNormal, cornerRadius: size), for: .normal)
        setBackgroundImage(UIImage.resizableImage(withColor: .primaryButtonHighlighted, cornerRadius: size), for: .highlighted)
        setBackgroundImage(UIImage.resizableImage(withColor: .primaryButtonDisabled, cornerRadius: size), for: .disabled)

        titleLabel?.font = .h4SemiBold
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = bounds.insetBy(dx: 5, dy: 5)
    }
}
