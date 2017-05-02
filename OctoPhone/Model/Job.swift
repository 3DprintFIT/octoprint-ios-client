//
//  Job.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 22/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// OctoPrint printing job
final class Job: Object {

    // MARK: - Stored properties

    /// File which is currently beeing printed,
    /// or file which was printed recently
    dynamic var fileName: String?

    /// Actual size of currently printed file
    let fileSize = RealmOptional<Int>()

    /// Indicates printing progress
    let completion = RealmOptional<Double>()

    /// Time for how long is the job running
    let printTime = RealmOptional<Int>()

    /// Estimated time of job completion
    let printTimeLeft = RealmOptional<Int>()

    /// Actual state of printer
    dynamic var state = ""

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(fileName: String?, fileSize: Int?, completion: Double?, printTime: Int?,
                     printTimeLeft: Int?, state: String) {

        self.init()

        self.fileName = fileName
        self.fileSize.value = fileSize
        self.completion.value = completion
        self.printTime.value = printTime
        self.printTimeLeft.value = printTimeLeft
        self.state = state
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "fileName"
    }
}
