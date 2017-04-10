//
//  OPDateFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

/// Provides standardized date formats
struct OPDateFormatter {
    /// Creates date from given timestamp
    ///
    /// - Parameter timestamp: UNIX timestamp
    /// - Returns: Formatted date representing given timestamp
    static func dateFromTimeStamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current

        return dateFormatter.string(from: date)
    }
}

// MARK: - Formatter reactive extension timestamps.
extension SignalProducer where Value == Int {
    /// Operator for timestamp (number) formatting. Maps given values of `self`
    /// to string represantation of date created from given timestamp.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatDate() -> SignalProducer<String, Error> {
        return map { OPDateFormatter.dateFromTimeStamp($0) }
    }
}
