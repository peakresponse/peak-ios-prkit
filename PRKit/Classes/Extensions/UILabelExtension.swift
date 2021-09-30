//
//  UILabel+Extension.swift
//  PRKit
//
//  Created by Francis Li on 8/18/20.
//

import UIKit

extension UILabel: Localizable {
    @IBInspectable public var l10nKey: String? {
        get { return nil }
        set { text = newValue?.localized }
    }

    @IBInspectable var customFont: String? {
        get { return nil }
        set { font = UIFont.value(forKey: newValue ?? "") as? UIFont }
    }

    func setBoldPrefixedText(boldFont: UIFont, prefix: String, text: String) {
        let attributedText = NSMutableAttributedString(string: "\(prefix)\(text)")
        attributedText.addAttribute(.font, value: boldFont, range: NSRange(prefix.startIndex..<prefix.endIndex, in: prefix))
        self.attributedText = attributedText
    }
}
