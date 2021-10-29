//
//  UIFont+Extension.swift
//  PRKit
//
//  Created by Francis Li on 8/5/20.
//

import Foundation
import UIKit

extension UIFont {
    @objc public static var body10Regular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 10) ?? .systemFont(ofSize: 10)
    }

    @objc public static var body10Bold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 10) ?? .boldSystemFont(ofSize: 10)
    }

    @objc public static var body14Regular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 14) ?? .systemFont(ofSize: 14)
    }

    @objc public static var body14Bold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 14) ?? .boldSystemFont(ofSize: 14)
    }

    @objc public static var h1: UIFont {
        return UIFont(name: "Barlow-Regular", size: 48) ?? .systemFont(ofSize: 48)
    }

    @objc public static var h1Bold: UIFont {
        return UIFont(name: "Barlow-Bold", size: 48) ?? .boldSystemFont(ofSize: 48)
    }

    @objc public static var h2: UIFont {
        return UIFont(name: "Barlow-Regular", size: 36) ?? .systemFont(ofSize: 36)
    }

    @objc public static var h2Bold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 36) ?? .boldSystemFont(ofSize: 36)
    }

    @objc public static var h3: UIFont {
        return UIFont(name: "Barlow-Regular", size: 24) ?? .systemFont(ofSize: 24)
    }

    @objc public static var h3SemiBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 24) ?? .boldSystemFont(ofSize: 24)
    }

    @objc public static var h4: UIFont {
        return UIFont(name: "Barlow-Regular", size: 20) ?? .systemFont(ofSize: 20)
    }

    @objc public static var h4SemiBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 20) ?? .boldSystemFont(ofSize: 20)
    }

    @objc public static var copyXSRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 10) ?? .systemFont(ofSize: 10)
    }

    @objc public static var copyXSBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 10) ?? .boldSystemFont(ofSize: 10)
    }

    @objc public static var copySRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 14) ?? .systemFont(ofSize: 14)
    }

    @objc public static var copySBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 14) ?? .boldSystemFont(ofSize: 14)
    }

    @objc public static var copyMRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 20) ?? .systemFont(ofSize: 20)
    }

    @objc public static var copyMBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 20) ?? .boldSystemFont(ofSize: 20)
    }

    @objc public static var copyLRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 24) ?? .systemFont(ofSize: 24)
    }

    @objc public static var copyLBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 24) ?? .boldSystemFont(ofSize: 24)
    }

    @objc public static var copyXLRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 36) ?? .systemFont(ofSize: 36)
    }

    @objc public static var copyXLBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 36) ?? .boldSystemFont(ofSize: 36)
    }

    @objc public static var copyXXLRegular: UIFont {
        return UIFont(name: "Barlow-Regular", size: 48) ?? .systemFont(ofSize: 48)
    }

    @objc public static var copyXXLBold: UIFont {
        return UIFont(name: "Barlow-SemiBold", size: 48) ?? .boldSystemFont(ofSize: 48)
    }
}
