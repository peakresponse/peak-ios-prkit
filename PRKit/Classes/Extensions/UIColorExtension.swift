//
//  UIColor+Extension.swift
//  PRKit
//
//  Created by Francis Li on 3/10/20.
//

import UIKit

public extension UIColor {
    // Helper for retrieving colors from the Assets xcassets bundle- providing an explicit Bundle
    // reference ensures this works in other contexts- including Interface Builder IBDesignable execution
    private static func named(_ name: String) -> UIColor {
        return UIColor(named: name, in: PRKitBundle.instance, compatibleWith: nil)!
    }

    static var base100: UIColor {
        return UIColor.named("Base100")
    }

    static var base300: UIColor {
        return UIColor.named("Base300")
    }

    static var base500: UIColor {
        return UIColor.named("Base500")
    }

    static var base800: UIColor {
        return UIColor.named("Base800")
    }

    static var brandPrimary100: UIColor {
        return UIColor.named("BrandPrimary100")
    }

    static var brandPrimary200: UIColor {
        return UIColor.named("BrandPrimary200")
    }

    static var brandPrimary300: UIColor {
        return UIColor.named("BrandPrimary300")
    }

    static var brandPrimary500: UIColor {
        return UIColor.named("BrandPrimary500")
    }

    static var brandPrimary600: UIColor {
        return UIColor.named("BrandPrimary600")
    }

    static var brandPrimary700: UIColor {
        return UIColor.named("BrandPrimary700")
    }

    static var brandPrimary900: UIColor {
        return UIColor.named("BrandPrimary900")
    }

    static var brandSecondary300: UIColor {
        return UIColor.named("BrandSecondary300")
    }

    static var brandSecondary400: UIColor {
        return UIColor.named("BrandSecondary400")
    }

    static var brandSecondary500: UIColor {
        return UIColor.named("BrandSecondary500")
    }

    static var brandSecondary800: UIColor {
        return UIColor.named("BrandSecondary800")
    }

    static var triageMinimalLight: UIColor {
        return UIColor.named("TriageMinimalLight")
    }

    static var triageMinimalMedium: UIColor {
        return UIColor.named("TriageMinimalMedium")
    }

    static var triageImmediateLight: UIColor {
        return UIColor.named("TriageImmediateLight")
    }

    static var triageImmediateMedium: UIColor {
        return UIColor.named("TriageImmediateMedium")
    }

    static var triageImmediateDark: UIColor {
        return UIColor.named("TriageImmediateDark")
    }

    static var triageDelayedLight: UIColor {
        return UIColor.named("TriageDelayedLight")
    }

    static var triageDelayedMedium: UIColor {
        return UIColor.named("TriageDelayedMedium")
    }

    static var triageExpectantLight: UIColor {
        return UIColor.named("TriageExpectantLight")
    }

    static var triageExpectantMedium: UIColor {
        return UIColor.named("TriageExpectantMedium")
    }

    static var triageDeadLight: UIColor {
        return UIColor.named("TriageDeadLight")
    }

    static var triageDeadMedium: UIColor {
        return UIColor.named("TriageDeadMedium")
    }

    static var triageTransportedLight: UIColor {
        return UIColor.named("TriageTransportedLight")
    }

    static var triageTransportedMedium: UIColor {
        return UIColor.named("TriageTransportedMedium")
    }

    // deprecated legacy colors -------------------

    static var immediateRed: UIColor {
        return UIColor.named("ImmediateRed")
    }

    static var immediateRedLightened: UIColor {
        return UIColor.named("LightImmediateRed")
    }

    static var delayedYellow: UIColor {
        return UIColor.named("DelayedYellow")
    }

    static var delayedYellowLightened: UIColor {
        return UIColor.named("LightDelayedYellow")
    }

    static var minimalGreen: UIColor {
        return UIColor.named("MinimalGreen")
    }

    static var minimalGreenLightened: UIColor {
        return UIColor.named("LightMinimalGreen")
    }

    static var expectantGray: UIColor {
        return UIColor.named("ExpectGrey")
    }

    static var expectantGrayLightened: UIColor {
        return UIColor.named("LightExpectGrey")
    }

    static var deadBlack: UIColor {
        return UIColor.named("DeadBlack")
    }

    static var deadBlackLightened: UIColor {
        return UIColor.named("LightDeadBlack")
    }

    static var peakBlue: UIColor {
        return UIColor.named("PeakBlue")
    }

    static var lightPeakBlue: UIColor {
        return UIColor.named("LightPeakBlue")
    }

    static var middlePeakBlue: UIColor {
        return UIColor.named("MiddlePeakBlue")
    }

    static var darkPeakBlue: UIColor {
        return UIColor.named("DarkPeakBlue")
    }

    static var greyPeakBlue: UIColor {
        return UIColor.named("GreyPeakBlue")
    }

    static var bgBackground: UIColor {
        return UIColor.named("BgBackground")
    }

    static var orangeAccent: UIColor {
        return UIColor.named("OrangeAccent")
    }

    static var mainGrey: UIColor {
        return UIColor.named("MainGrey")
    }

    static var lowPriorityGrey: UIColor {
        return UIColor.named("LowPriorityGrey")
    }

    static var lightGreyBlue: UIColor {
        return UIColor.named("LightGreyBlue")
    }

    static var backgroundBlueGray: UIColor {
        return UIColor(r: 229, g: 236, b: 239)
    }

    static var bottomBlueGray: UIColor {
        return UIColor(r: 245, g: 247, b: 249)
    }

    static var natBlue: UIColor {
        return UIColor(r: 70, g: 165, b: 219)
    }

    static var natBlueLightened: UIColor {
        return UIColor(r: 208, g: 233, b: 247)
    }

    static var gray2: UIColor {
        return UIColor(r: 79, g: 79, b: 79)
    }

    static var gray3: UIColor {
        return UIColor(r: 130, g: 130, b: 130)
    }

    static var gray4: UIColor {
        return UIColor(r: 189, g: 189, b: 189)
    }

    static var purple2: UIColor {
        return UIColor(r: 187, g: 107, b: 217)
    }

    static var green3: UIColor {
        return UIColor(r: 111, g: 207, b: 151)
    }

    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }

    func colorWithBrightnessMultiplier(multiplier: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * multiplier, alpha: a)
    }
}
