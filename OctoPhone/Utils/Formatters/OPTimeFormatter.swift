//
//  OPTimeFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

/// Provides standardized date formats
struct OPTimeFormatter {
    /// Creates formatted duration string from seconds. The returned format
    /// is always HH:MM:SS.
    ///
    /// - Parameter value: Amount of seconds
    /// - Returns: Formatted duration value
    static func durationFormSeconds(_ value: Int) -> String {
        let hours = value / 3600
        let minutes = (value / 60) % 60
        let seconds = value % 60

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

// MARK: - Formatter reactive extension for time format.
extension SignalProducer where Value == Int {
    /// Operator for seconds (number) formatting. Maps given values of `self`
    /// to string represantation of duration.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatDuration() -> SignalProducer<String, Error> {
        return map { OPTimeFormatter.durationFormSeconds($0) }
    }
}
