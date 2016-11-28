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

    init(configuration: OperationConfiguration) {
        contextManager = configuration.contextManager
        sessionManager = configuration.sessionManager
    }

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


struct OperationConfiguration {
    var contextManager: ContextManager

    var sessionManager: SessionManager
}
