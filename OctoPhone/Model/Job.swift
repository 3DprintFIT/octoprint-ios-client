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
    dynamic var fileName = ""

    /// Actual size of currently printed file
    dynamic var fileSize = 0

    /// Indicates printing progress
    dynamic var completion = 0.0

    /// Time for how long is the job running
    dynamic var printTime = 0

    /// Estimated time of job completion
    dynamic var printTimeLeft = 0

    /// Actual state of printer
    dynamic var state = ""

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(fileName: String, fileSize: Int, completion: Double, printTime: Int,
                     printTimeLeft: Int, state: String) {

        self.init()

        self.fileName = fileName
        self.fileSize = fileSize
        self.completion = completion
        self.printTime = printTime
        self.printTimeLeft = printTimeLeft
        self.state = state
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "fileName"
    }
}
