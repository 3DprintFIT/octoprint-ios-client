//
//  Bed.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents current state of printing bed
final class Bed: Object {

    // MARK: - Stored properties

    /// Actual temperature of bed
    dynamic var actualTemperature = 0.0

    /// Target temperature of bed
    dynamic var targetTemperature = 0.0

    /// Offset temperature of bed
    dynamic var offsetTemperature = 0.0

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(actualTemperature: Double, targetTemperature: Double, offsetTemperature: Double) {
        self.init()

        self.actualTemperature = actualTemperature
        self.targetTemperature = targetTemperature
        self.offsetTemperature = offsetTemperature
    }

    // MARK: - Realm API
}
