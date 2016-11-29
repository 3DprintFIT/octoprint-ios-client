//
//  NetworkController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


class PrinterController: NSObject {

    private let queue = OperationQueue()

    private let contextManager: ContextManager

    private let sessionManager: SessionManager

    private let operationConfiguration: OperationConfiguration

    private let printerURL: URL

    init(printerURL: URL, contextManager: ContextManager) {
        let sessionManager = SessionManager()

        self.contextManager = contextManager
        self.sessionManager = sessionManager
        self.printerURL = printerURL

        operationConfiguration = OperationConfiguration(
            contextManager: contextManager,
            sessionManager: sessionManager,
            baseURL: printerURL
        )
    }

    func login(with token: String, to printerUrl: URL) -> LoginPromise {
        let promise = LoginPromise(with: token, printerUrl: printerUrl)
        let loginOperation = LoginOperation(configuration: operationConfiguration, loginPromise: promise)

        queue.addOperation(loginOperation)

        return promise
    }
}
