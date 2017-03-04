//
//  GCodeAnalysis.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Computed analysis for gcode
final class GCodeAnalysis: Object {
    // MARK: - Stored properties
    
    /// Estimated printing time of gcode file
    dynamic var estimatedPrintTime = 0

    /// Length of used filament
    dynamic var filamentLength = 0

    /// Volume of used filament
    dynamic var filamentVolume = 0.0

    // MARK: - Public API

    convenience init(estimatedPrintTime: Int, filamentLength: Int, filamentVolume: Double) {
        self.init()

        self.estimatedPrintTime = estimatedPrintTime
        self.filamentLength = filamentLength
        self.filamentVolume = filamentVolume
    }
}
