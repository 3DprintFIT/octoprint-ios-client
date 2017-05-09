//
//  Tool.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Print tool object
final class Tool {

    // MARK: - Stored properties

    /// Actual temperature of hotend
    var actualTemperature = 0.0

    /// Offset temperature
    var offsetTemperature = 0.0

    /// Target temperature
    var targetTemperature = 0.0

    // MARK: - Computed properties

    // MARK: - Public API

    init(actual: Double, offset: Double, target: Double) {
        self.actualTemperature = actual
        self.offsetTemperature = offset
        self.targetTemperature = target
    }

    // MARK: - Realm API
}
