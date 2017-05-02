//
//  OPTemperatureFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

/// Provides standardized date formats
struct OPTemperatureFormatter {
    /// Creates formatted celsius temperature from raw number
    ///
    /// - Parameter timestamp: Amount of degrees in Celsius
    /// - Returns: Formatted temperature with degrees sign
    static func temperatureFromNumber(_ value: Double) -> String {
        let temperature = OPNumberFormatter.shared.plainNumber(value)

        return "\(temperature) °C"
    }
}

// MARK: - Formatter reactive extension for temperature format.
extension SignalProducer where Value == Double {
    /// Operator for temperature (number) formatting. Maps given values of `self`
    /// to string represantation of temperature in Celsius degrees.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatTemperature() -> SignalProducer<String, Error> {
        return map { OPTemperatureFormatter.temperatureFromNumber($0) }
    }
}
