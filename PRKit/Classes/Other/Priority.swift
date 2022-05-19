//
//  Priority.swift
//  PRKit
//
//  Created by Francis Li on 5/19/22.
//

import Foundation

let PRIORITY_COLORS: [UIColor] = [
    .triageImmediateMedium,
    .triageDelayedMedium,
    .triageMinimalMedium,
    .triageExpectantMedium,
    .triageDeadMedium
]

let PRIORITY_LABEL_COLORS: [UIColor] = [
    .white,
    .white,
    .white,
    .white,
    .white
]

let PRIORITY_COLORS_LIGHTENED: [UIColor] = [
    .triageImmediateLight,
    .triageDelayedLight,
    .triageMinimalLight,
    .triageExpectantLight,
    .triageDeadLight
]

public enum Priority: Int, CustomStringConvertible, CaseIterable {
    case immediate
    case delayed
    case minimal
    case expectant
    case dead

    public var description: String {
        return "Priority.\(rawValue)".localized
    }

    public var abbrDescription: String {
        return "Priority.abbr.\(rawValue)".localized
    }

    public var color: UIColor {
        return PRIORITY_COLORS[rawValue]
    }

    public var labelColor: UIColor {
        return PRIORITY_LABEL_COLORS[rawValue]
    }

    public var lightenedColor: UIColor {
        return PRIORITY_COLORS_LIGHTENED[rawValue]
    }
}
