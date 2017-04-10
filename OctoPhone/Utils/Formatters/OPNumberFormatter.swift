//
//  OPNumberFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// OctoPrint standard formatter
final class OPNumberFormatter {

    /// Shared instance of formatter
    static var shared = OPNumberFormatter()

    /// Shared instance for palin number formatter
    private let standardNumberFormatter: NumberFormatter = {
        let decimalFormatter = NumberFormatter()

        decimalFormatter.numberStyle = .decimal
        decimalFormatter.locale = Locale.current

        return decimalFormatter
    }()

    /// Shared instance for measurements formatting
    private let measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()

        formatter.locale = Locale.current
        formatter.unitOptions = .naturalScale

        return formatter
    }()

    private init() { }

    /// Standardized format for plain integer numbers
    ///
    /// - Parameter number: Integer number to be formatted
    /// - Returns: String represetation of given number with standard format
    func plainNumber(_ number: Int) -> String {
        return standardNumberFormatter.string(from: NSNumber(value: number))!
    }

    /// Standardized format for plain double numbers
    ///
    /// - Parameter number: Double number to be formatted
    /// - Returns: String represetation of given number with standard format
    func plainNumber(_ number: Double) -> String {
        return standardNumberFormatter.string(from: NSNumber(value: number))!
    }

    /// Formats given amount to length string
    ///
    /// - Parameters:
    ///   - amount: Actual amount of unformatted length
    ///   - unit: Unit of given amount. Default `millimeter`
    /// - Returns: Formatted length string
    func length(_ amount: Double, fromUnit unit: UnitLength = .millimeters) -> String {
        return measurementFormatter.string(from: Measurement(value: amount, unit: unit))
    }

    /// Formats given amount to volume string
    ///
    /// - Parameters:
    ///   - amount: Actual amount of unformatted volume
    ///   - unit: Unit of given amount. Default `squareMillimeters`
    /// - Returns: Formatted volume string
    func volume(_ amount: Double, unit: UnitArea = .squareMillimeters) -> String {
        return measurementFormatter.string(from: Measurement(value: amount, unit: unit))
    }
}
