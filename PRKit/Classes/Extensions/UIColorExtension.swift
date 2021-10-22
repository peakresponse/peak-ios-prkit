//
//  UIColor+Extension.swift
//  PRKit
//
//  Created by Francis Li on 3/10/20.
//

import UIKit

private class UIColorExtension {
}

extension UIColor {
    // Helper for retrieving colors from the Assets xcassets bundle- providing an explicit Bundle
    // reference ensures this works in other contexts- including Interface Builder IBDesignable execution
    private static func named(_ name: String) -> UIColor {
        return UIColor(named: name, in: Bundle(for: UIColorExtension.self), compatibleWith: nil)!
    }

    public static var base100: UIColor {
        return UIColor.named("Base100")
    }

    public static var base300: UIColor {
        return UIColor.named("Base300")
    }

    public static var base500: UIColor {
        return UIColor.named("Base500")
    }

    public static var base800: UIColor {
        return UIColor.named("Base800")
    }

    public static var brandPrimary100: UIColor {
        return UIColor.named("BrandPrimary100")
    }

    public static var brandPrimary200: UIColor {
        return UIColor.named("BrandPrimary200")
    }

    public static var brandPrimary300: UIColor {
        return UIColor.named("BrandPrimary300")
    }

    public static var brandPrimary500: UIColor {
        return UIColor.named("BrandPrimary500")
    }

    public static var brandPrimary600: UIColor {
        return UIColor.named("BrandPrimary600")
    }

    public static var brandPrimary700: UIColor {
        return UIColor.named("BrandPrimary700")
    }

    public static var brandPrimary900: UIColor {
        return UIColor.named("BrandPrimary900")
    }

    public static var brandSecondary300: UIColor {
        return UIColor.named("BrandSecondary300")
    }

    public static var brandSecondary400: UIColor {
        return UIColor.named("BrandSecondary400")
    }

    public static var brandSecondary500: UIColor {
        return UIColor.named("BrandSecondary500")
    }

    public static var brandSecondary800: UIColor {
        return UIColor.named("BrandSecondary800")
    }

    public static var immediateRed: UIColor {
        return UIColor.named("ImmediateRed")
    }

    public static var immediateRedLightened: UIColor {
        return UIColor.named("LightImmediateRed")
    }

    public static var delayedYellow: UIColor {
        return UIColor.named("DelayedYellow")
    }

    public static var delayedYellowLightened: UIColor {
        return UIColor.named("LightDelayedYellow")
    }

    public static var minimalGreen: UIColor {
        return UIColor.named("MinimalGreen")
    }

    public static var minimalGreenLightened: UIColor {
        return UIColor.named("LightMinimalGreen")
    }

    public static var expectantGray: UIColor {
        return UIColor.named("ExpectGrey")
    }

    public static var expectantGrayLightened: UIColor {
        return UIColor.named("LightExpectGrey")
    }

    public static var deadBlack: UIColor {
        return UIColor.named("DeadBlack")
    }

    public static var deadBlackLightened: UIColor {
        return UIColor.named("LightDeadBlack")
    }

    public static var peakBlue: UIColor {
        return UIColor.named("PeakBlue")
    }

    public static var lightPeakBlue: UIColor {
        return UIColor.named("LightPeakBlue")
    }

    public static var middlePeakBlue: UIColor {
        return UIColor.named("MiddlePeakBlue")
    }

    public static var darkPeakBlue: UIColor {
        return UIColor.named("DarkPeakBlue")
    }

    public static var greyPeakBlue: UIColor {
        return UIColor.named("GreyPeakBlue")
    }

    public static var bgBackground: UIColor {
        return UIColor.named("BgBackground")
    }

    public static var orangeAccent: UIColor {
        return UIColor.named("OrangeAccent")
    }

    public static var mainGrey: UIColor {
        return UIColor.named("MainGrey")
    }

    public static var lowPriorityGrey: UIColor {
        return UIColor.named("LowPriorityGrey")
    }

    public static var lightGreyBlue: UIColor {
        return UIColor.named("LightGreyBlue")
    }

    // deprecated legacy colors -------------------

    public static var backgroundBlueGray: UIColor {
        return UIColor(r: 229, g: 236, b: 239)
    }

    public static var bottomBlueGray: UIColor {
        return UIColor(r: 245, g: 247, b: 249)
    }

    public static var natBlue: UIColor {
        return UIColor(r: 70, g: 165, b: 219)
    }

    public static var natBlueLightened: UIColor {
        return UIColor(r: 208, g: 233, b: 247)
    }

    public static var gray2: UIColor {
        return UIColor(r: 79, g: 79, b: 79)
    }

    public static var gray3: UIColor {
        return UIColor(r: 130, g: 130, b: 130)
    }

    public static var gray4: UIColor {
        return UIColor(r: 189, g: 189, b: 189)
    }

    public static var red: UIColor {
        return UIColor(r: 235, g: 87, b: 87)
    }

    public static var purple2: UIColor {
        return UIColor(r: 187, g: 107, b: 217)
    }

    public static var yellow: UIColor {
        return UIColor(r: 242, g: 201, b: 76)
    }

    public static var green3: UIColor {
        return UIColor(r: 111, g: 207, b: 151)
    }

    convenience public init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }

    public func colorWithBrightnessMultiplier(multiplier: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * multiplier, alpha: a)
    }
}
