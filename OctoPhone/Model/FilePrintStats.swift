//
//  FilePrintStats.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Print history statistics for file
final class FilePrintStats: Object {

    // MARK: - Stored properties

    /// Count of fail prints
    dynamic var failures = 0

    /// Count of success prints
    dynamic var successes = 0

    /// Timestamp of last print
    dynamic var lastPrint = 0

    /// Last print success indicator
    dynamic var wasLastPrintSuccess = true

    // MARK: - Public API

    /// Creates new file print statistics object
    ///
    /// - Parameters:
    ///   - failures: Count of failures
    ///   - successes: Count of success prints
    ///   - lastPrint: Timestamp of last print
    ///   - wasLastPrintSuccess: Last print success indicator
    convenience init(failures: Int, successes: Int, lastPrint: Int, wasLastPrintSuccess: Bool) {
        self.init()

        self.failures = failures
        self.successes = successes
        self.lastPrint = lastPrint
        self.wasLastPrintSuccess = wasLastPrintSuccess
    }
}
