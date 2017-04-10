//
//  OPNumberFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

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

// MARK: - Formatting reactive extension for Int values
extension SignalProducer where Value == Int {
    /// Operator for plain number format. Maps given values of `self`
    /// to string representation of number.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatNumber() -> SignalProducer<String, Error> {
        return map { OPNumberFormatter.shared.plainNumber($0) }
    }
}

// MARK: - Formatting reactive extension for Int values
extension SignalProducer where Value == Double {
    /// Operator for plain number format. Maps given values of `self`
    /// to string representation of number.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatNumber() -> SignalProducer<String, Error> {
        return map { OPNumberFormatter.shared.plainNumber($0) }
    }

    /// Operator for length number formatting. Maps given value of `self`
    /// to formatted length string representation.
    ///
    /// - Parameter units: Units type of `self`
    /// - Returns: Produler with formatted value of `self`
    func formatLength(units: UnitLength = .millimeters) -> SignalProducer<String, Error> {
        return map { OPNumberFormatter.shared.length($0, fromUnit: units) }
    }

    /// Operator for area number formatting. Maps given value of `self`
    /// to formatted area string representation.
    ///
    /// - Parameter units: Units type of `self`
    /// - Returns: Produler with formatted value of `self`
    func formatVolume(units: UnitArea = .squareMillimeters) -> SignalProducer<String, Error> {
        return map { OPNumberFormatter.shared.volume($0, unit: units) }
    }
}
