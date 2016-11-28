//
//  NetworkController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


class NetworkController: NSObject {

    private let queue = OperationQueue()

    private let contextManager: ContextManager

    private let sessionManager: SessionManager

    private let operationConfiguration: OperationConfiguration

    init(contextManager: ContextManager) {
        let sessionManager = SessionManager()

        self.contextManager = contextManager
        self.sessionManager = sessionManager

        operationConfiguration = OperationConfiguration(
            contextManager: contextManager,
            sessionManager: sessionManager
        )
    }
}
