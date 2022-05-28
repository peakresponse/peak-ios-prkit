//
//  TriagePriority.swift
//  PRKit
//
//  Created by Francis Li on 5/19/22.
//

import Foundation

let TriageColors: [UIColor] = [
    .triageImmediateMedium,
    .triageDelayedMedium,
    .triageMinimalMedium,
    .triageExpectantMedium,
    .triageDeadMedium,
    .triageTransportedMedium,
    .base500
]

let TriageColorsLightened: [UIColor] = [
    .triageImmediateLight,
    .triageDelayedLight,
    .triageMinimalLight,
    .triageExpectantLight,
    .triageDeadLight,
    .triageTransportedLight,
    .base300
]

let TriageLabelColors: [UIColor] = [
    .white,
    .white,
    .white,
    .white,
    .white,
    .white,
    .white
]

public enum TriagePriority: Int, CustomStringConvertible, CaseIterable {
    case immediate
    case delayed
    case minimal
    case expectant
    case dead
    case transported
    case unknown

    public var description: String {
        return "TriagePriority.\(rawValue)".localized
    }

    public var abbrDescription: String {
        return "TriagePriority.abbr.\(rawValue)".localized
    }

    public var color: UIColor {
        return TriageColors[rawValue]
    }

    public var labelColor: UIColor {
        return TriageLabelColors[rawValue]
    }

    public var lightenedColor: UIColor {
        return TriageColorsLightened[rawValue]
    }
}
