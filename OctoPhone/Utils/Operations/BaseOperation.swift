//
//  BaseOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation

/// Represents base work unit
class BaseOperation: Operation {

    /// Indicicates wheter the operation is finished or not
    var internalIsFinished = false
    override var isFinished: Bool {
        get {
            return internalIsFinished
        }
        set {
            willChangeValue(forKey: "isFinished")
            internalIsFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
}
