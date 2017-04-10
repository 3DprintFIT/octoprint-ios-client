//
//  OPDateFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

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
