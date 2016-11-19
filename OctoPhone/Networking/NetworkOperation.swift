//
//  NetworkOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


class NetworkOperation: Operation {
    var contextManager: ContextManager!

    var sessionManager: SessionManager!

    var error: Error?

    var internalFinished = false
    override var isFinished: Bool {
        get {
            return internalFinished
        }
        set {
            internalFinished = newValue
        }
    }
}
