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
        decimalFormatter.groupingSeparator = " "

        return decimalFormatter
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
}
