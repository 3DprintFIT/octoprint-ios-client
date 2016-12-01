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
        var apiURL = printerURL

        if apiURL.lastPathComponent != "api" {
            apiURL.appendPathComponent("api")
        }

        self.contextManager = contextManager
        self.sessionManager = sessionManager
        self.printerURL = apiURL

        operationConfiguration = OperationConfiguration(
            contextManager: contextManager,
            sessionManager: sessionManager,
            baseURL: apiURL
        )
    }

    func autheticate(with token: String) -> AuthenticationPromise {
        let promise = AuthenticationPromise(with: token, printerURL: printerURL)
        let authOperation = AuthenticatateOperation(
            configuration: operationConfiguration,
            authenticationPromise: promise
        )

        queue.addOperation(authOperation)

        return promise
    }
}
