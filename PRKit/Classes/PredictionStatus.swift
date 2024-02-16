//
//  PredictionStatus.swift
//  PRKit
//
//  Created by Francis Li on 10/25/20.
//

import Foundation

public enum PredictionStatus: String {
    case none
    case unconfirmed = "UNCONFIRMED"
    case confirmed = "CONFIRMED"
    case corrected = "CORRECTED"
}
